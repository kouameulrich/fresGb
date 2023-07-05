

import 'dart:developer';

import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;


class RequestInterceptor extends Interceptor{
  final Dio dio = Dio();
  String? accessToken;
  String? tenantID;
  static const String TOKEN_KEY = "TOKEN";
  final tokenStorageService = locator<TokenStorageService>();
  RequestInterceptor();

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('-----------------interceptor-----------------');
    print('REQUEST[${options.method}] => PATH: ${options.path}');
    accessToken =  await tokenStorageService.retrieveAccessToken() ;
    tenantID = await tokenStorageService.retrieveTenant();
    print('-----------------access token retrieved-----------------');
    print(accessToken);
    print('-----------------tenantId retrieved-----------------');
    print(tenantID);
    options.headers['Authorization'] = 'Bearer $accessToken';
    options.headers['X-TenantID'] = '$tenantID';
    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if ((err.response?.statusCode == 401 /*&&
        err.response?.data['message'] == "Invalid JWT"*/)) {
      if (await tokenStorageService.isTokenExist()) {
        if (await refreshToken()) {
          return handler.resolve(await _retry(err.requestOptions));
        }
      }
    }
    return handler.next(err);
    }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    print('-----------------Testing refresh token-----------------');
    final refreshToken = await tokenStorageService.retrieveRefreshToken();
    final tenantID = await tokenStorageService.retrieveTenant();
    String url = 'https://auth.simbo.me/auth/realms/$tenantID/protocol/openid-connect/token';
    var response = await http.post(Uri.parse(
        url),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded"
        }, body: {
          "refresh_token": refreshToken,
          "grant_type": "refresh_token",
          "client_id": "simbowebfrontend"
        });
    // final response = await dio.post('/auth/refresh', data: {'refreshToken': refreshToken});
    if (response.statusCode == 200) {
      tokenStorageService.deleteToken(TOKEN_KEY);
      tokenStorageService.saveToken(response.body);
      accessToken = await tokenStorageService.retrieveAccessToken();
      //accessToken = response.data;
      log('-----------------token refreshed-----------------');
      return true;
    } else {
      print('-----------------refresh token is wrong-----------------');
      // refresh token is wrong
      accessToken = null;
      tokenStorageService.deleteAllToken();
      return false;
    }
  }
}
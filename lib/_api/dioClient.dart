// ignore_for_file: unused_catch_clause

import 'dart:convert';

import 'package:appfres/_api/endpoints.dart';
import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/di/service_locator.dart';
import 'package:dio/dio.dart';

class DioClient {
  // dio instance
  final Dio _dio;
  Dio dioLogin = Dio();

  String? accessToken;
  String? tenantID;
  static const String TOKEN_KEY = "TOKEN";
  final tokenStorageService = locator<TokenStorageService>();
  // injecting dio instance
  DioClient(this._dio) {
    _dio
      ..options.baseUrl = Endpoints.baseUrl
      ..options.connectTimeout = Endpoints.connectionTimeout
      ..options.receiveTimeout = Endpoints.receiveTimeout
      ..options.responseType = ResponseType.json
      /* ..interceptors.add(LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
      ))*/
      ..interceptors
          .add(InterceptorsWrapper(onRequest: (options, handler) async {
        print('-----------------interceptor-----------------');
        print('REQUEST[${options.method}] => PATH: ${options.path}');
        accessToken = await tokenStorageService.retrieveAccessToken();
        tenantID = await tokenStorageService.retrieveTenant();
        print('-----------------access token retrieved-----------------');
        print(accessToken);
        print('-----------------tenantId retrieved-----------------');
        print(tenantID);
        options.headers['Authorization'] = 'Bearer $accessToken';
        options.headers['X-TenantID'] = '$tenantID';
        return handler.next(options);
      }, onError: (DioError err, handler) async {
        if ((err.response?.statusCode ==
                401 /*&&
        err.response?.data['message'] == "Invalid JWT"*/
            )) {
          if (await tokenStorageService.isTokenExist()) {
            if (await refreshToken()) {
              return handler.resolve(await _retry(err.requestOptions));
            }
          }
        }
        return handler.next(err);
      }));
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }

  Future<bool> refreshToken() async {
    print('-----------------Testing refresh token-----------------');
    final refreshToken = await tokenStorageService.retrieveRefreshToken();
    final tenantID = await tokenStorageService.retrieveTenant();
    String url =
        'https://localhost:8080/auth/realms/$tenantID/protocol/openid-connect/token';
    try {
      final Response response = await dioLogin.post(url,
          data: {
            "refresh_token": refreshToken,
            "grant_type": "refresh_token",
            "client_id": "fresapp-client"
          },
          options: Options(
              contentType: Headers.formUrlEncodedContentType,
              responseType: ResponseType.json));
      tokenStorageService.deleteToken(TOKEN_KEY);
      tokenStorageService.saveToken(json.encode(response.data));
      accessToken = await tokenStorageService.retrieveAccessToken();
      print('-----------------token refreshed-----------------');
      return true;
    } on DioError catch (e) {
      print('-----------------refresh token is wrong-----------------');
      // refresh token is wrong
      // accessToken = null;
      // tokenStorageService.deleteAllToken();
      return false;
    }
  }

  // Get:-----------------------------------------------------------------------
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Post:----------------------------------------------------------------------
  Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Put:-----------------------------------------------------------------------
  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  // Delete:--------------------------------------------------------------------
  Future<dynamic> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response response = await _dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}

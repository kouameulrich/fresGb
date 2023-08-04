// import 'dart:convert';

// import 'package:appfres/_api/tokenStorageService.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';

// class AuthService {
//   final TokenStorageService _tokenStorageService;
//   Dio dio = Dio();

//   AuthService(this._tokenStorageService);
//   Future<int?> authenticateUser(
//       String tenantID, String username, String password) async {
//     _tokenStorageService.saveTenantId(tenantID);

//     String url =
//         'https://localhost:8080/auth/realms/$tenantID/protocol/openid-connect/token';
//     final Response response = await dio.post(url,
//         data: {
//           "username": username,
//           "password": password,
//           "client_id": "fresapp-client",
//           "grant_type": "password",
//           "scope": "email openid profile"
//         },
//         options: Options(
//             contentType: Headers.formUrlEncodedContentType,
//             responseType: ResponseType.json));
//     if (response.statusCode == 200) {
//       print(json.encode(response.data));
//       _tokenStorageService.saveToken(json.encode(response.data));
//       print('--------------access-------------------');
//       print(await _tokenStorageService.retrieveAccessToken());
//       print('-----------refresh----------------------');
//       print(await _tokenStorageService.retrieveRefreshToken());
//       return response.statusCode;
//     } else {
//       debugPrint(
//           "An Error Occurred during loggin in. Status code: ${response.statusCode} , body: ${response.data}");
//       return response.statusCode;
//     }
//   }
// }
// ignore_for_file: file_names, avoid_print
import 'dart:convert';

import 'package:appfres/_api/tokenStorageService.dart';
import 'package:appfres/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final TokenStorageService _tokenStorageService;
  Dio dio = Dio();

  AuthService(this._tokenStorageService);

  Future<int?> authenticateUser(
      String usernameController, String passwordController) async {
    String url = 'http://192.168.1.8:8080/api/auth/signin';
    var response = await http.post(Uri.parse(url),
        headers: {"Content-type": "application/json"},
        body: jsonEncode({
          "email": usernameController,
          "password": passwordController,
        }));
    print(usernameController);
    print(passwordController);
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      User apiResponse = User.fromJson(jsonResponse);
      _tokenStorageService.saveAgentConnected(apiResponse);
      return response.statusCode;
    } else {
      debugPrint(
          "An Error Occurred during loggin in. Status code: ${response.statusCode} , body: ${response.body}");
      return response.statusCode;
    }
  }

  // Future<int?> sendData() async {
  //   var headersList = {'Accept': '*/*', 'Content-Type': 'application/json'};
  //   var url = Uri.parse('http://192.168.1.8:8080/api/public/bulkPayments');

  //   var body = [
  //     {
  //       "agent": {"id": "64a4a22663cdbd123d85937f"},
  //       "contract": {"reference": "C380014"},
  //       "amount": "35000.00",
  //       "paymentDate": "2023-07-29T12:02:01.411+00:00"
  //     }
  //   ];

  //   var req = http.Request('POST', url);
  //   req.headers.addAll(headersList);
  //   req.body = json.encode(body);

  //   var res = await req.send();
  //   final resBody = await res.stream.bytesToString();

  //   if (res.statusCode >= 200 && res.statusCode < 300) {
  //     print(resBody);
  //   } else {
  //     print(res.reasonPhrase);
  //   }
  // }
}

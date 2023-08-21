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
    String url = 'https://www.digitale-it.com/fres/api/auth/signin';

    var headersList = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
    };

    var body = {
      "email": usernameController,
      "password": passwordController,
    };

    try {
      var response = await dio.post(url,
          options: Options(headers: headersList), data: jsonEncode(body));

      print(usernameController);
      print(passwordController);

      if (response.statusCode == 200) {
        _tokenStorageService.saveToken(json.encode(response.data));
        var jsonResponse = response.data;
        User apiResponse = User.fromJson(jsonResponse);
        _tokenStorageService.saveAgentConnected(apiResponse);
        return response.statusCode;
      } else {
        debugPrint(
            "An Error Occurred during logging in. Status code: ${response.statusCode} , body: ${response.data}");
        return response.statusCode;
      }
    } catch (error) {
      debugPrint("An Error Occurred during logging in: $error");
      return null;
    }
  }
}

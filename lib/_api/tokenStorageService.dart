// ignore_for_file: file_names, constant_identifier_names

import 'package:appfres/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorageService {
  // Create storage
  final FlutterSecureStorage _storage;
  static const String TOKEN_KEY = "TOKEN";
  static const String ID_KEY = "MAT";
  static const String EMAIL_KEY = "EMAIL";
  static const String PHONENUMBER_KEY = "PHONENUMBER";
  static const String PASSWORD_KEY = "PASSWORD";
  static const String FIRSTNAME_KEY = "FIRSTNAME";
  static const String LASTNAME_KEY = "LASTNAME";
  static const String LAST_AUTH_DATETIME = "LASTAUTHDATIME";

  TokenStorageService(this._storage);

  void saveAgentConnected(User agent) async {
    await _storage.write(key: ID_KEY, value: agent.id);
    await _storage.write(key: EMAIL_KEY, value: agent.email);
    await _storage.write(key: PHONENUMBER_KEY, value: agent.phoneNumber);
    await _storage.write(key: PASSWORD_KEY, value: agent.password);
    await _storage.write(key: FIRSTNAME_KEY, value: agent.firstname);
    await _storage.write(key: LASTNAME_KEY, value: agent.lastname);
    await _storage.write(key: TOKEN_KEY, value: agent.token);
    await _storage.write(
        key: LAST_AUTH_DATETIME, value: DateTime.now().toString());
    print(DateTime.now().toString());
  }

  Future<User?> retrieveAgentConnected() async {
    String? id = await _storage.read(key: ID_KEY);
    String? email = await _storage.read(key: EMAIL_KEY);
    String? phoneNumber = await _storage.read(key: PHONENUMBER_KEY);
    String? password = await _storage.read(key: PASSWORD_KEY);
    String? firstName = await _storage.read(key: FIRSTNAME_KEY);
    String? lastName = await _storage.read(key: LASTNAME_KEY);
    String? token = await _storage.read(key: TOKEN_KEY);
    String? lastConnection = await _storage.read(key: LAST_AUTH_DATETIME);
    User agentConnected = User(
      id: id ?? "",
      email: email ?? "",
      phoneNumber: phoneNumber ?? "",
      password: password ?? "",
      firstname: firstName ?? "",
      lastname: lastName ?? "",
      token: token ?? '',
      lastConnection: lastConnection ?? '',
    );
    return (agentConnected);
  }

  Future<void> deleteAllToken() async {
    _storage.deleteAll();
  }

  deleteToken(String tokenKey) {
    _storage.delete(key: tokenKey);
  }

  void saveToken(String token) async {
    await _storage.write(key: TOKEN_KEY, value: token);
  }
}

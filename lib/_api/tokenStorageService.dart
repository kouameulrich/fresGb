
import 'dart:convert';

import 'package:appfres/models/agent.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/tokenModel.dart';


class TokenStorageService{
  // Create storage
   final FlutterSecureStorage _storage;
   static const String TOKEN_KEY = "TOKEN";
   static const String TENANT_KEY = "TENANT_ID";
   static const String USER_KEY = "USER";
   static const String MAT_KEY = "MAT";
   static const String USERNAME_KEY = "USERNAME";
   static const String NOM_KEY = "NOM";
   static const String PRENOM_KEY = "PRENOM";

   TokenStorageService(this._storage);

   void saveToken(String token) async {
    await _storage.write(key: TOKEN_KEY, value: token);
  }
   void saveTenantId(String tenant) async {
     await _storage.write(key: TENANT_KEY, value: tenant);
   }

   void saveAgentConnected(Agent agent) async {
     await _storage.write(key: MAT_KEY, value: agent.matricule);
     await _storage.write(key: USERNAME_KEY, value: agent.nomUtilisateur);
     await _storage.write(key: NOM_KEY, value: agent.nom);
     await _storage.write(key: PRENOM_KEY, value: agent.prenom);
   }
   void saveAgentMatricule(String matricule) async {
     await _storage.write(key: MAT_KEY, value: matricule);
   }
   void saveAgentUsername(String username) async {
     await _storage.write(key: USERNAME_KEY, value: username);
   }
   void saveAgentNom(String nom) async {
     await _storage.write(key: NOM_KEY, value: nom);
   }
   void saveAgentPrenom(String prenom) async {
     await _storage.write(key: PRENOM_KEY, value: prenom);
   }
   Future<Agent?> retrieveAgentConnected() async {
     String? matricule = await _storage.read(key: MAT_KEY);
     String? username = await _storage.read(key: USERNAME_KEY);
     String? nom = await _storage.read(key: NOM_KEY);
     String? prenom = await _storage.read(key: PRENOM_KEY);
     Agent agentConnected = Agent(matricule: matricule,nomUtilisateur: username,nom: nom,prenom: prenom);
     return agentConnected;
   }

   Future<String?> retrieveTenant() async {
     String? tenant = await _storage.read(key: TENANT_KEY);
     if (tenant == null) {
       return null;
     }
     return tenant;
   }

  Future<String?> retrieveAccessToken() async {
    String? tokenJson = await _storage.read(key: TOKEN_KEY);
    if (tokenJson == null) {
      return null;
    }
    return TokenModel.fromJson(jsonDecode(tokenJson)).accessToken;
  }

  Future<String?> retrieveRefreshToken() async {
    String? tokenJson = await _storage.read(key: TOKEN_KEY);
    if (tokenJson == null) {
      return null;
    }
    return TokenModel.fromJson(jsonDecode(tokenJson)).refreshToken;
  }
  Future<bool> isTokenExist() async {
   return await _storage.containsKey(key: TOKEN_KEY);
  }
  Future<void> deleteAllToken() async {
    _storage.deleteAll();
  }
  deleteToken(String tokenKey){
    _storage.delete(key: tokenKey);
  }
}
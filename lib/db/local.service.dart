import 'package:appfres/db/repository.dart';
import 'package:appfres/models/encaissement.dart';
import 'package:appfres/models/user.dart';

class LocalService {
  final Repository _repository;

  LocalService(this._repository);

  // Recensement

  //Save Recensement
  SaveEncaissement(Encaissement encaissement) async {
    return await _repository.insertData('encaissement', encaissement.toJson());
  }

  //Read All Recensement
  Future<List<Encaissement>> readAllEncaissement() async {
    List<Encaissement> encaissements = [];
    List<Map<String, dynamic>> list =
        await _repository.readData('encaissement');
    for (var encaissement in list) {
      encaissements.add(Encaissement.fromJson(encaissement));
    }
    return encaissements;
  }

  //Edit Recensement
  UpdateEncaissement(Encaissement encaissement) async {
    return await _repository.updateData('encaissement', encaissement.toJson());
  }

  // delete Recensement
  deleteEncaissement(encaissementId) async {
    return await _repository.deleteDataById('encaissement', encaissementId);
  }

  Future<List<User>> login() async {
    List<User> users = [];
    List<Map<String, dynamic>> list = await _repository.readData('users');
    for (var user in list) {
      users.add(User.fromJson(user));
    }
    return users;
  }
}

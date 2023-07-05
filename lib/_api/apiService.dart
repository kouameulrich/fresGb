import 'dart:convert';
import 'package:appfres/_api/endpoints.dart';
import 'package:appfres/models/agent.dart';
import 'package:appfres/models/dto/encaisement.dto.dart';
import 'package:appfres/models/encaissement.dart';
import 'dioClient.dart';

class ApiService {
  final DioClient _dioClient;
  ApiService(this._dioClient);

  Future<Agent> getUserConnected(String username) async {
    String agentEndpoint = '/agents/$username/slim/byusername';
    final response = await _dioClient.get(agentEndpoint);
    return Agent.fromJson(response.data);
  }

//--------- SEND RECENSEMENT -----------//
  Future<void> sendRecensement(List<Encaissement> encaissements) async {
    final encaissementJson = convertRecencementToRecensementDto(encaissements)
        .map((e) => e.toJson())
        .toList();
    print(json.encode(encaissementJson));
    await _dioClient.post(Endpoints.encaissements,
        data: json.encode(encaissementJson));
  }

  List<EncaissementDto> convertRecencementToRecensementDto(
      List<Encaissement> encaissements) {
    List<EncaissementDto> encaissementDto = [];
    for (var r in encaissements) {
      EncaissementDto r1 = EncaissementDto(
        nomClient: r.nomClient,
        prenomClient: r.prenomClient,
        telephoneClient: r.telephoneClient,
        dateEncaissement: r.dateEncaissement!.substring(0, 10),
        matriculeAgent: r.matriculeAgent,
        sexeClient: r.sexeClient == 'Feminin' ? 'F' : 'M',
        montantClient: r.montantClient,
      );
      encaissementDto.add(r1);
    }
    return encaissementDto;
  }
}

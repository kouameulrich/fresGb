import 'package:appfres/models/contractType.dart';

class Contract {
  late String id;
  late String reference;
  late String offer;
  late List<ContractType> types;

  Contract({
    required this.id,
    required this.reference,
    required this.offer,
    required this.types,
  });

  Contract.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reference = json['reference'];
    offer = json['offer'];

    var typeObjsJson = ((json['types'] ?? []) as List);
    List<ContractType> _types = typeObjsJson
        .map((typeJson) => ContractType.fromJson(typeJson))
        .toList();
    types = _types;
  }
}

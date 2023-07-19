import 'package:appfres/models/dto/contract.dart';

class Customer {
  String? id;
  int? reference;
  String? firstName;
  String? lastName;
  String? village;
  String? phoneNumber;
  List<Contract> contracts;

  Customer(
      {required this.id,
      required this.reference,
      required this.firstName,
      required this.lastName,
      required this.village,
      required this.phoneNumber,
      required this.contracts});

  factory Customer.fromJson(Map<String, dynamic> json) {
    var matObjsJson = ((json['contracts'] ?? []) as List);
    List<Contract> matJson =
        matObjsJson.map((e) => Contract.fromJson(e)).toList();

    return Customer(
        id: json['id'],
        reference: json['reference'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        village: json['village'],
        phoneNumber: json['phoneNumber'],
        contracts: matJson);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reference'] = reference;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['village'] = village;
    data['phoneNumber'] = phoneNumber;
    //data['contracts'] = contracts;
    return data;
  }
}

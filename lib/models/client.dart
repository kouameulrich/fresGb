import 'package:appfres/models/user.dart';

class Client {
  String id;
  String firstName;
  String lastName;
  String village;
  String phoneNumber;
  String registrationDate;
  List<User> user;
  List<String> contracts;

  Client(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.village,
      required this.phoneNumber,
      required this.registrationDate,
      required this.user,
      required this.contracts});

  factory Client.fromJson(Map<String, dynamic> json) {
    var userObjsJson = ((json['user'] ?? []) as List);
    List<User> userJson = userObjsJson.map((e) => User.fromJson(e)).toList();

    return Client(
        id: json['id'],
        firstName: json['firstName'],
        lastName: json['lastName'],
        village: json['village'],
        phoneNumber: json['phoneNumber'],
        registrationDate: json['registrationDate'],
        user: userJson,
        contracts: []);
  }
}

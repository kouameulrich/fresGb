import 'package:appfres/models/roles.dart';

class User {
  late String id;
  late String email;
  late String phoneNumber;
  late String password;
  late String firstname;
  late String lastname;
  late String autorisation;
  late List<Role> roles;

  @override
  String toString() {
    return 'User{id: $id, email: $email, phoneNumber: $phoneNumber, password: $password, firstname: $firstname, lastname: $lastname, autorisation: $autorisation}';
  }

  User(
      {required this.id,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.firstname,
      required this.lastname,
      required this.autorisation,
      required this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    autorisation = json['autorisation'];

    var roleObjsJson = ((json['roles'] ?? []) as List);
    List<Role> _roles =
        roleObjsJson.map((roleJson) => Role.fromJson(roleJson)).toList();
    roles = _roles;
  }
}

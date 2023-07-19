class User {
  String? id;
  String? email;
  String? phoneNumber;
  String? password;
  String? firstname;
  String? lastname;

  @override
  String toString() {
    return 'User{id: $id, email: $email, phoneNumber: $phoneNumber, password: $password, firstname: $firstname, lastname: $lastname}';
  }

  User(
      {required this.id,
      required this.email,
      required this.phoneNumber,
      required this.password,
      required this.firstname,
      required this.lastname});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phoneNumber = json['phoneNumber'];
    password = json['password'];
    firstname = json['firstName'];
    lastname = json['lastName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phoneNumber'] = phoneNumber;
    data['password'] = password;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    return data;
  }
}

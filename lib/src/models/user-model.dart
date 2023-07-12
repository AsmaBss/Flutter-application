import 'package:flutter_application/src/models/role-model.dart';

class UserModel {
  int? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;
  Set<RoleModel>? roles;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.firstname,
    this.lastname,
    this.roles, // = const {},
  });

  @override
  String toString() {
    return 'User { id: $id, email: $email, '
        'password: $password, firstname: $firstname, '
        'lastname: $lastname, roles: $roles}\n'; //
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      roles: (json['roles'] as List<dynamic>)
          .map((roleJson) => RoleModel.fromJson(roleJson))
          .toSet(),
    );
  }

  Map<String, dynamic> toJson(UserModel p) {
    return {
      'id': p.id,
      'email': p.email,
      'password': p.password,
      'firstname': p.firstname,
      'lastname': p.lastname,
      'roles': p.roles?.map((role) => role.toJson(role)).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(email: map['email'] ?? "")
      ..password = (map['password'] ?? "")
      ..firstname = (map['firstname'] ?? "")
      ..lastname = (map['lastname'] ?? "")
      ..roles = (map['roles'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'roles': roles,
    };
  }
}

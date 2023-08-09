import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/role-model.dart';

class UserModel {
  int? id;
  String? email;
  String? password;
  String? firstname;
  String? lastname;
  //Set<RoleModel>? roles;
  int? role_id;
  Set<ParcelleModel>? parcelles;

  UserModel({
    this.id,
    this.email,
    this.password,
    this.firstname,
    this.lastname,
    this.role_id, // = const {},
    this.parcelles,
  });

  @override
  String toString() {
    return 'User { id: $id, email: $email, '
        'password: $password, firstname: $firstname, '
        'lastname: $lastname, role_id: $role_id, parcelles: $parcelles}\n'; //
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      email: json['email'] as String,
      password: json['password'] as String,
      firstname: json['firstname'] as String,
      lastname: json['lastname'] as String,
      /*roles: (json['roles'] as List<dynamic>)
          .map((roleJson) => RoleModel.fromJson(roleJson))
          .toSet(),*/
      role_id: json['roles'][0]['id'],
      parcelles: (json['parcelles'] as List<dynamic>)
          .map((parcelleJson) => ParcelleModel.fromJson(parcelleJson))
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
      //'roles': p.roles?.map((role) => role.toJson(role)).toList(),
      'role_id': p.role_id,
      'parcelles':
          p.parcelles?.map((parcelle) => parcelle.toJson(parcelle)).toList(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(id: map['id'] ?? "")
      ..email = (map['email'] ?? "")
      ..password = (map['password'] ?? "")
      ..firstname = (map['firstname'] ?? "")
      ..lastname = (map['lastname'] ?? "")
      ..role_id = (map['role_id'] ?? "");
    /*..parcelles = (map['parcelles'] as List<dynamic>?)
          ?.map((parcelleJson) => ParcelleModel.fromJson(parcelleJson))
          .toSet();*/
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'firstname': firstname,
      'lastname': lastname,
      'role_id': role_id,
      //'parcelles': parcelles,
    };
  }
}

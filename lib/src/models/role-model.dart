import 'package:flutter_application/src/models/TypeRoleEnum.dart';

class RoleModel {
  int? id;
  TypeRoleEnum? type;

  RoleModel({
    this.id,
    this.type,
  });

  @override
  String toString() {
    return 'Role { id: $id, type: $type}\n';
  }

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] as int,
      type: json['type'] != null ? TypeRoleEnum.fromJson(json['type']) : null,
    );
  }

  Map<String, dynamic> toJson(RoleModel p) {
    return {
      'id': p.id,
      'type': p.type!.toJson(),
    };
  }

  factory RoleModel.fromMap(Map<String, dynamic> map) {
    return RoleModel(
      id: map['id'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
    };
  }
}

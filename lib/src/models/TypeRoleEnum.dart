enum TypeRoleEnum {
  ADMIN,
  SUPERVISOR,
  SIMPLE_USER;

  String toJson() => toString().split('.').last;

  static TypeRoleEnum fromJson(String json) {
    switch (json) {
      case 'ADMIN':
        return TypeRoleEnum.ADMIN;
      case 'SUPERVISOR':
        return TypeRoleEnum.SUPERVISOR;
      case 'SIMPLE_USER':
        return TypeRoleEnum.SIMPLE_USER;
      default:
        throw Exception('Invalid TypeRoleEnum: $json');
    }
  }
}

extension TypeRoleEnumExtension on TypeRoleEnum {
  String get sentence {
    switch (this) {
      case TypeRoleEnum.ADMIN:
        return "ADMIN";
      case TypeRoleEnum.SUPERVISOR:
        return "SUPERVISOR";
      case TypeRoleEnum.SIMPLE_USER:
        return "SIMPLE_USER";
    }
  }
}

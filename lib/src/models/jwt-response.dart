import 'package:flutter_application/src/models/user-model.dart';

class JwtResponse {
  final UserModel user;
  final String jwtToken;

  JwtResponse({required this.user, required this.jwtToken});

  factory JwtResponse.fromJson(Map<String, dynamic> json) {
    return JwtResponse(
      user: UserModel.fromJson(json['user']),
      jwtToken: json['jwtToken'],
    );
  }
  factory JwtResponse.fromMap(Map<String, dynamic> map) {
    return JwtResponse(
      user: UserModel.fromMap(map['user']),
      jwtToken: map['jwtToken'] ?? '',
    );
  }
}

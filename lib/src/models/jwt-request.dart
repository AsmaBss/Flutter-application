class JwtRequest {
  final String username;
  final String password;

  JwtRequest({required this.username, required this.password});

  Map<String, dynamic> toJson(JwtRequest jwtRequest) {
    return {
      'username': username,
      'password': password,
    };
  }
}

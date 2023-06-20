import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/jwt-request.dart';
import 'package:flutter_application/src/models/jwt-response.dart';
import 'package:flutter_application/src/models/user-model.dart';
import 'package:flutter_application/src/screens/login.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final ApiServices _apiServices = ApiServices();

  Future<JwtResponse> login(JwtRequest jwtRequest, BuildContext context) async {
    try {
      http.Response response = await _apiServices
          .post("/authenticate", jwtRequest.toJson(jwtRequest), noAuth: true);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return JwtResponse.fromJson(jsonData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Email ou mot de passe invalide"),
        ));
      }
    } catch (e) {
      print('Erreur: $e');
    }
    throw Exception("An error occurred");
  }

  register(UserModel user, BuildContext context) async {
    try {
      http.Response response = await _apiServices
          .post("/register/3", user.toJson(user), noAuth: true);
      if (response.statusCode == 200) {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (BuildContext context) => Login()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Problème au niveau de serveur: ${response.statusCode}"),
        ));
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/jwt-request.dart';
import 'package:flutter_application/src/models/jwt-response.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final ApiServices _apiServices = ApiServices();

  Future<JwtResponse> login(JwtRequest jwtRequest, BuildContext context) async {
    try {
      http.Response response = await _apiServices.post(
          "/authenticate", jwtRequest.toJson(jwtRequest), noAuth: true);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return JwtResponse.fromJson(jsonData);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Problème au niveau de serveur: ${response.statusCode}"),
        ));
      }
    } catch (e) {
      print('Erreur: $e');
    }
    throw Exception("Echec !");
  }

  register() {}
}

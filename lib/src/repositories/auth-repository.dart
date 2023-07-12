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
        final jsonResponse = jsonDecode(response.body);
        var x = jsonResponse['message'];
        if (response.statusCode == 401) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(x),
          ));
        } else if (response.statusCode == 403) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(x),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(x),
          ));
        }
      }
    } catch (e) {
      print('Erreur: $e');
    }
    throw Exception("An error occurred");
  }
}

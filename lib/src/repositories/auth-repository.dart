import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/jwt-request.dart';
import 'package:flutter_application/src/models/jwt-response.dart';
import 'package:flutter_application/src/sqlite/user-query.dart';
import 'package:http/http.dart' as http;

class AuthRepository {
  final ApiServices _apiServices = ApiServices();

  Future<JwtResponse?> login(
      JwtRequest jwtRequest, BuildContext context) async {
    //try {
    http.Response response = await _apiServices
        .post("/authenticate", jwtRequest.toJson(jwtRequest), noAuth: true);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return JwtResponse.fromJson(jsonData);
    } else {
      if (response.statusCode == 401) {
        final jsonResponse = jsonDecode(response.body);
        var x = jsonResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(x),
        ));
      } else if (response.statusCode == 403) {
        final jsonResponse = jsonDecode(response.body);
        var x = jsonResponse['message'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(x),
        ));
      } else {
        return UserQuery().retrieveUser(jwtRequest, context);
      }
    }
    /*} on Exception catch (e) {
      throw Exception(e.toString());
    }*/
  }
}

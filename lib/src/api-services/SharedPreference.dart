import 'dart:convert';

import 'package:flutter_application/src/models/user-model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  // Storing JWT token in local storage
  Future<void> storeJwtToken(String jwtToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', jwtToken);
  }

  // Retrieving JWT token from local storage
  Future<String?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  // Removing the JWT token
  Future<void> removeJwtToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('jwtToken');
  }

  // Storing User in local storage
  Future<void> storeUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJsonString = json.encode(user.toJson(user));
    await prefs.setString('user', userJsonString);
  }
  /*Map<String, dynamic> decodeOptions = user.toJson(user);
    await prefs.setString('user', decodeOptions.toString());*/

  // Retrieving User from local storage
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> json = jsonDecode(userJson);
      return UserModel.fromJson(json);
    } else {
      return null;
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/jwt-request.dart';
import 'package:flutter_application/src/models/jwt-response.dart';
import 'package:flutter_application/src/models/user-model.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class UserQuery {
  Future<void> insertUsers() async {
    await SQLiteWrapper().execute("DELETE FROM user");
    await SQLiteWrapper().execute("DELETE FROM user_parcelle");
    List<UserModel>? list = await SqliteApi().getAllUsers();
    for (final l in list!) {
      for (var element in l.parcelles!) {
        await SQLiteWrapper().insert({
          "user_id": l.id,
          "parcelle_id": element.id,
        }, 'user_parcelle');
      }
      await SQLiteWrapper().insert(l.toMap(), 'user');
    }
    showUsers().then((value) => print("user : $value"));
    showUsersParcelles().then((value) => print("user_parcelle : $value"));
  }

  Future<List<UserModel>?> showUsers() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM user");
    final List<UserModel> list =
        result.map((row) => UserModel.fromMap(row)).toList();
    return list;
  }

  Future<List> showUsersParcelles() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM user_parcelle");
    final List list = result;
    return list;
  }

  Future<JwtResponse?> retrieveUser(
      JwtRequest jwtRequest, BuildContext context) async {
    final dynamic result = await SQLiteWrapper().query(
        "SELECT * FROM user where email = ?",
        params: [jwtRequest.username],
        singleResult: true);
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Email introuvable"),
      ));
      return null;
    } else {
      UserModel user = UserModel.fromMap(result);
      final isValidPassword = await FlutterBcrypt.verify(
          password: jwtRequest.password, hash: user.password!);
      if (isValidPassword) {
        final JwtResponse list =
            JwtResponse.fromMap({"user": user.toMap(), "jwtToken": null});
        return list;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Mot de passe incorrecte"),
        ));
        return null;
      }
    }
  }
}

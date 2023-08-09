import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SecurisationQuery {
  Future<void> insertSecurisations() async {
    await SQLiteWrapper().execute("DELETE FROM securisation");
    List<SecurisationModel>? list = await SqliteApi().getAllSecurisations();
    for (final l in list!) {
      await SQLiteWrapper().insert(l.toMap(), 'securisation');
      SynchronisationQuery().insertSynchronisation(
          "securisation", l.id!, "insert", json.encode(l.toJson(l)));
    }
    showSecurisations().then((value) => print("securisation : $value"));
  }

  Future<List<SecurisationModel>?> showSecurisations() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM securisation");
    final List<SecurisationModel> list =
        result.map((row) => SecurisationModel.fromMap(row)).toList();
    return list;
  }

  Future<SecurisationModel?> showSecurisationByParcelleId(
      int parcelleId) async {
    final dynamic result = await SQLiteWrapper().query(
        "SELECT * FROM securisation where parcelle = ? ",
        params: [parcelleId],
        singleResult: true);
    if (result == null) {
      return null;
    } else {
      final SecurisationModel list = SecurisationModel.fromMap(result);
      return list;
    }
  }

  void addSecurisation(SecurisationModel s, BuildContext context) async {
    int id = await SQLiteWrapper().insert(s.toMap(), "securisation");
    s.id = id;
    SynchronisationQuery().insertSynchronisation(
        "securisation", id, "insert", json.encode(s.toJson(s)));
    Navigator.pop(context, true);
    showSecurisations();
  }

  Future<void> deleteSecurisation(
      SecurisationModel s, BuildContext context) async {
    await SQLiteWrapper().delete(s.toMap(), "securisation", keys: ["id"]);
    SynchronisationQuery().deleteSynchronisation(
        "securisation", s.id!, "delete", json.encode(s.toJson(s)));
    Navigator.pop(context);
    showSecurisations();
  }

  Future<void> updateSecurisation(
      SecurisationModel s, BuildContext context) async {
    await SQLiteWrapper().update(s.toMap(), "securisation", keys: ["id"]);
    SynchronisationQuery().updateSynchronisation(
        "securisation", s.id!, "update", json.encode(s.toJson(s)));
    Navigator.pop(context, true);
    showSecurisations();
  }
}

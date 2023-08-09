import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class PasseQuery {
  Future<void> insertPasses() async {
    await SQLiteWrapper().execute("DELETE FROM passe");
    List<PasseModel>? passes = await SqliteApi().getAllPasses();
    for (final passe in passes!) {
      await SQLiteWrapper().insert(passe.toMap(), 'passe');
      SynchronisationQuery().insertSynchronisation(
          "passe", passe.id!, "insert", json.encode(passe.toJson(passe)));
    }
    showPasses().then((value) => print("passes : $value"));
  }

  Future<List<PasseModel>?> showPasses() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM passe");
    final List<PasseModel> passes =
        result.map((row) => PasseModel.fromMap(row)).toList();
    return passes;
  }

  Future<List> showPasseByPrelevementId(int id) async {
    final List<dynamic> result = await SQLiteWrapper()
        .query("SELECT * FROM passe WHERE prelevement = ?", params: [id]);
    final List<PasseModel> list =
        result.map((row) => PasseModel.fromMap(row)).toList();
    return list;
  }

  void addPasse(PasseModel o) async {
    if (o.id == null) {
      int id = await SQLiteWrapper().insert(o.toMap(), "passe");
      o.id = id;
      SynchronisationQuery().insertSynchronisation(
          "passe", id, "insert", json.encode(o.toJson(o)));
    } else {
      updatePasse(o);
    }
    showPasses();
  }

  void updatePasse(PasseModel s) async {
    await SQLiteWrapper().update(s.toMap(), "passe", keys: ["id"]);
    SynchronisationQuery().updateSynchronisation(
        "passe", s.id!, "update", json.encode(s.toJson(s)));
    showPasses();
  }

  Future<void> deletePasse(PasseModel o, BuildContext context) async {
    await SQLiteWrapper().delete(o.toMap(), "passe", keys: ["id"]);
    SynchronisationQuery().deleteSynchronisation(
        "passe", o.id!, "delete", json.encode(o.toJson(o)));
    showPasses();
    Navigator.pop(context);
  }

  Future<void> deleteAllPasse(PrelevementModel o) async {
    final List<dynamic> result = await SQLiteWrapper().query(
      "SELECT * FROM passe WHERE prelevement = ?",
      params: [o.id],
    );
    final List<PasseModel> list =
        result.map((row) => PasseModel.fromMap(row)).toList();
    for (var i in list) {
      SynchronisationQuery().deleteSynchronisation(
          "passe", i.id!, "delete", json.encode(i.toJson(i)));
      await SQLiteWrapper().delete(i.toMap(), "passe", keys: ["id"]);
    }
    showPasses();
  }
}

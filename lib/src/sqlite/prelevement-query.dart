import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ImageModel.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:flutter_application/src/sqlite/images-query.dart';
import 'package:flutter_application/src/sqlite/passe-query.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class PrelevementQuery {
  Future<void> insertPrelevements() async {
    await SQLiteWrapper().execute("DELETE FROM prelevement");
    List<PrelevementModel>? list = await SqliteApi().getAllPRelevements();
    for (final l in list!) {
      await SQLiteWrapper().insert(l.toMap(), 'prelevement');
      SynchronisationQuery().insertSynchronisation(
          "prelevement", l.id!, "insert", json.encode(l.toJson(l)));
    }
    showPrelevements().then((value) => print("prelevement : $value"));
  }

  Future<List<PrelevementModel>?> showPrelevements() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM prelevement");
    final List<PrelevementModel> list =
        result.map((row) => PrelevementModel.fromMap(row)).toList();
    return list;
  }

  Future<PrelevementModel?> showPrelevementByPS(int planSondageId) async {
    final dynamic result = await SQLiteWrapper().query(
        "SELECT * FROM prelevement where planSondage = ? ",
        params: [planSondageId],
        singleResult: true);
    if (result == null) {
      return null;
    } else {
      final PrelevementModel list = PrelevementModel.fromMap(result);
      return list;
    }
  }

  void addPrelevement(PrelevementModel p, List<ImageModel> images,
      List<PasseModel> passes, BuildContext context) async {
    int id = await SQLiteWrapper().insert(p.toMap(), "prelevement");
    p.id = id;
    SynchronisationQuery().insertSynchronisation(
        "prelevement", id, "insert", json.encode(p.toJson(p)));
    showPrelevements();
    for (var i in images) {
      i.prelevement = id;
      ImagesQuery().addImagesObservation(i);
    }
    for (var i in passes) {
      i.prelevement = id;
      PasseQuery().addPasse(i);
    }
    Navigator.pop(context, true);
  }

  Future<void> updatePrelevement(PrelevementModel s, List<ImageModel> images,
      List<PasseModel> passes, BuildContext context) async {
    await SQLiteWrapper().update(s.toMap(), "prelevement", keys: ["id"]);
    SynchronisationQuery().updateSynchronisation(
        "prelevement", s.id!, "update", json.encode(s.toJson(s)));
    showPrelevements();
    for (var i in images) {
      ImagesQuery().addImagesObservation(i);
    }
    for (var i in passes) {
      PasseQuery().addPasse(i);
    }
    Navigator.pop(context, true);
  }

  Future<void> deletePrelevement(
      PrelevementModel o, BuildContext context) async {
    await ImagesQuery().deleteAllImagesPrelevement(o);
    await PasseQuery().deleteAllPasse(o);
    await SQLiteWrapper().delete(o.toMap(), "prelevement", keys: ["id"]);
    SynchronisationQuery().deleteSynchronisation(
        "prelevement", o.id!, "delete", json.encode(o.toJson(o)));
    showPrelevements();
    Navigator.pop(context);
  }
}

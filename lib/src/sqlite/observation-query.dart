import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:flutter_application/src/sqlite/images-observation.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class ObservationQuery {
  Future<void> insertObservations() async {
    await SQLiteWrapper().execute("DELETE FROM observation");
    List<ObservationModel>? observations =
        await SqliteApi().getAllObservations();
    for (final observation in observations!) {
      await SQLiteWrapper().insert(observation.toMap(), 'observation');
      SynchronisationQuery().insertSynchronisation(
          "observation",
          observation.id!,
          "insert",
          json.encode(observation.toJson(observation)));
    }
    showObservations().then((value) => print("observation : $value"));
  }

  Future<List<ObservationModel>?> showObservations() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM observation");
    final List<ObservationModel> observation =
        result.map((row) => ObservationModel.fromMap(row)).toList();
    return observation;
  }

  Future<List<ObservationModel>?> showObservationByParcelleId(
      int parcelleId) async {
    final List<dynamic> result = await SQLiteWrapper().query(
      "SELECT * FROM observation WHERE parcelle = ?",
      params: [parcelleId],
    );
    final List<ObservationModel> list =
        result.map((row) => ObservationModel.fromMap(row)).toList();
    return list;
  }

  Future<ObservationModel?> showObservationByLatAndLng(
      String latitude, String longitude) async {
    final dynamic result = await SQLiteWrapper().query(
        "SELECT * FROM observation WHERE latitude = ? AND longitude = ?",
        params: [latitude, longitude],
        singleResult: true);
    final ObservationModel list = ObservationModel.fromMap(result);
    return list;
  }

  void addObservation(ObservationModel o, List<ImagesObservationModel> images,
      BuildContext context) async {
    int id = await SQLiteWrapper().insert(o.toMap(), "observation");
    o.id = id;
    SynchronisationQuery().insertSynchronisation(
        "observation", id, "insert", json.encode(o.toJson(o)));
    showObservations();
    for (var i in images) {
      i.observation = id;
      ImagesObservationQuery().addImagesObservation(i);
    }
    Navigator.pop(context, true);
  }

  Future<void> updateObservation(ObservationModel s,
      List<ImagesObservationModel> images, BuildContext context) async {
    await SQLiteWrapper().update(s.toMap(), "observation", keys: ["id"]);
    SynchronisationQuery().updateSynchronisation(
        "observation", s.id!, "update", json.encode(s.toJson(s)));
    showObservations();
    for (var i in images) {
      ImagesObservationQuery().addImagesObservation(i);
    }
    Navigator.pop(context, true);
  }

  Future<void> deleteObservation(
      ObservationModel o, BuildContext context) async {
    await ImagesObservationQuery().deleteAllImagesObservation(o);
    await SQLiteWrapper().delete(o.toMap(), "observation", keys: ["id"]);
    SynchronisationQuery().deleteSynchronisation(
        "observation", o.id!, "delete", json.encode(o.toJson(o)));
    Navigator.pop(context);
    showObservations();
  }
}

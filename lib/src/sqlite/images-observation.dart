import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class ImagesObservationQuery {
  Future<void> insertImagesObservations() async {
    await SQLiteWrapper().execute("DELETE FROM images_observation");
    List<ImagesObservationModel>? observations =
        await SqliteApi().getAllImagesObservation();
    for (final observation in observations!) {
      await SQLiteWrapper().insert(observation.toMap(), 'images_observation');
      SynchronisationQuery().insertSynchronisation(
          "images_observation",
          observation.id!,
          "insert",
          json.encode(observation.toJson(observation)));
    }
    showImagesObservations()
        .then((value) => print("images_observation : $value"));
  }

  Future<List<ImagesObservationModel>?> showImagesObservations() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM images_observation");
    final List<ImagesObservationModel> observation =
        result.map((row) => ImagesObservationModel.fromMap(row)).toList();
    return observation;
  }

  Future<List> showImagesObservationByObservationId(int id) async {
    final List<dynamic> result = await SQLiteWrapper().query(
        "SELECT * FROM images_observation WHERE observation = ?",
        params: [id]);
    final List<ImagesObservationModel> list =
        result.map((row) => ImagesObservationModel.fromMap(row)).toList();
    return list;
  }

  void addImagesObservation(ImagesObservationModel o) async {
    if (o.id == null) {
      int id = await SQLiteWrapper().insert(o.toMap(), "images_observation");
      o.id = id;
      SynchronisationQuery().insertSynchronisation(
          "images_observation", id, "insert", json.encode(o.toJson(o)));
    } else {
      updateImagesObservation(o);
    }
    showImagesObservations();
  }

  void updateImagesObservation(ImagesObservationModel o) async {
    await SQLiteWrapper().update(o.toMap(), "images_observation", keys: ["id"]);
    SynchronisationQuery().updateSynchronisation(
        "images_observation", o.id!, "update", json.encode(o.toJson(o)));
  }

  Future<void> deleteImageObservation(
      ImagesObservationModel o, BuildContext context) async {
    await SQLiteWrapper().delete(o.toMap(), "images_observation", keys: ["id"]);
    SynchronisationQuery().deleteSynchronisation(
        "images_observation", o.id!, "delete", json.encode(o.toJson(o)));
    showImagesObservations();
    Navigator.pop(context);
  }

  Future<void> deleteAllImagesObservation(ObservationModel o) async {
    final List<dynamic> result = await SQLiteWrapper().query(
      "SELECT * FROM images_observation WHERE observation = ?",
      params: [o.id],
    );
    final List<ImagesObservationModel> list =
        result.map((row) => ImagesObservationModel.fromMap(row)).toList();
    for (var i in list) {
      SynchronisationQuery().deleteSynchronisation(
          "images_observation", i.id!, "delete", json.encode(i.toJson(i)));
      await SQLiteWrapper()
          .delete(i.toMap(), "images_observation", keys: ["id"]);
    }
    //showImagesObservations();
  }
}

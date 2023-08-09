import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/ImageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class ImagesQuery {
  Future<void> insertImagesPrelevement() async {
    await SQLiteWrapper().execute("DELETE FROM images_prelevement");
    List<ImageModel>? images = await SqliteApi().getAllImagesPrelevement();
    for (final image in images!) {
      await SQLiteWrapper().insert(image.toMap(), 'images_prelevement');
      SynchronisationQuery().insertSynchronisation("images_prelevement",
          image.id!, "insert", json.encode(image.toJson(image)));
    }
    showImagesPrelevement()
        .then((value) => print("images_prelevement : $value"));
  }

  Future<List<ImageModel>?> showImagesPrelevement() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM images_prelevement");
    final List<ImageModel> images =
        result.map((row) => ImageModel.fromMap(row)).toList();
    return images;
  }

  Future<List> showImagesPrelevementByPrelevementId(int id) async {
    final List<dynamic> result = await SQLiteWrapper().query(
        "SELECT * FROM images_prelevement WHERE prelevement = ?",
        params: [id]);
    final List<ImageModel> list =
        result.map((row) => ImageModel.fromMap(row)).toList();
    return list;
  }

  void addImagesObservation(ImageModel o) async {
    if (o.id == null) {
      int id = await SQLiteWrapper().insert(o.toMap(), "images_prelevement");
      o.id = id;
      SynchronisationQuery().insertSynchronisation(
          "images_prelevement", id, "insert", json.encode(o.toJson(o)));
    } else {
      updateImagesObservation(o);
    }
    showImagesPrelevement();
  }

  void updateImagesObservation(ImageModel o) async {
    await SQLiteWrapper().update(o.toMap(), "images_prelevement", keys: ["id"]);
    SynchronisationQuery().updateSynchronisation(
        "images_prelevement", o.id!, "update", json.encode(o.toJson(o)));
  }

  Future<void> deleteImagePrelevement(
      ImageModel o, BuildContext context) async {
    await SQLiteWrapper().delete(o.toMap(), "images_prelevement", keys: ["id"]);
    SynchronisationQuery().deleteSynchronisation(
        "images_prelevement", o.id!, "delete", json.encode(o.toJson(o)));
    showImagesPrelevement();
    Navigator.pop(context);
  }

  Future<void> deleteAllImagesPrelevement(PrelevementModel o) async {
    final List<dynamic> result = await SQLiteWrapper().query(
      "SELECT * FROM images_prelevement WHERE prelevement = ?",
      params: [o.id],
    );
    final List<ImageModel> list =
        result.map((row) => ImageModel.fromMap(row)).toList();
    for (var i in list) {
      SynchronisationQuery().deleteSynchronisation(
          "images_prelevement", i.id!, "delete", json.encode(i.toJson(i)));
      await SQLiteWrapper()
          .delete(i.toMap(), "images_prelevement", keys: ["id"]);
    }
  }
}

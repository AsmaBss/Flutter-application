import 'package:flutter/material.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class DatabaseHelper {
  static final DatabaseHelper _singleton = DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _singleton;
  }

  DatabaseHelper._internal();

  initDB({inMemory = false}) async {
    String dbPath = inMemoryDatabasePath;

    if (!inMemory) {
      final docDir = await getApplicationDocumentsDirectory();

      if (!await docDir.exists()) {
        await docDir.create(recursive: true);
      }
      dbPath = p.join(docDir.path, "mydatabase.sqlite");
    }

    final DatabaseInfo dbInfo =
        await SQLiteWrapper().openDB(dbPath, onCreate: () async {
      const String sql1 = """
        CREATE TABLE IF NOT EXISTS "position" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "addresse" varchar(255) NOT NULL,
            "description" varchar(255) NOT NULL,
            "latitude" varchar(255) NOT NULL,
            "longitude" varchar(255) NOT NULL
          );""";
      const String sql2 = """
        CREATE TABLE IF NOT EXISTS "position_details" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "image" varchar(255) NOT NULL,
            "position_id" integer NOT NULL
          );""";

      await SQLiteWrapper().execute(sql1);
      await SQLiteWrapper().execute(sql2);
    });
    // Print where the database is stored
    debugPrint("Database path: ${dbInfo.path}");
  }

  closeDB() {
    SQLiteWrapper().closeDB();
  }

  Future<List> showPositions() async {
    return await SQLiteWrapper().query("SELECT * FROM position");
  }

  Future<List> showPositionByLatAndLng(
      String latitude, String longitude) async {
    return await SQLiteWrapper().query(
        "SELECT * FROM position WHERE latitude = ? AND longitude = ?",
        params: [latitude, longitude]);
  }

  Future<List> showPositionDistinctLatAndLng(
      String latitude, String longitude) async {
    return await SQLiteWrapper().query(
        "SELECT DISTINCT latitude, longitude FROM position WHERE latitude = ? AND longitude = ?",
        params: [latitude, longitude]);
  }

  void addPosition(String addresse, String description, String latitude,
      String longitude) async {
    await SQLiteWrapper().insert(
        PositionModel(
                addresse: addresse,
                description: description,
                latitude: latitude,
                longitude: longitude)
            //, image: image)
            .toMap(),
        "position");
    print("Data inserted in local !");
  }

  void deletePosition(PositionModel position) async {
    await SQLiteWrapper().delete(position.toMap(), "position", keys: ["id"]);
    print("Data deleted in local !");
  }

  void updatePosition(PositionModel position) async {
    await SQLiteWrapper().update(position.toMap(), "position", keys: ["id"]);
    print("Data updated in local !");
  }
}

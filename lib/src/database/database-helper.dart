import 'package:flutter/material.dart';
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

    final DatabaseInfo dbInfo = await SQLiteWrapper().openDB(dbPath);
    /* await SQLiteWrapper().openDB(dbPath, onCreate: () async {
      const String sql1 = """
        CREATE TABLE IF NOT EXISTS "position" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "address" varchar(255) NOT NULL,
            "description" varchar(255) NOT NULL,
            "latitude" varchar(255) NOT NULL,
            "longitude" varchar(255) NOT NULL
          );""";
      const String sql2 = """
        CREATE TABLE IF NOT EXISTS "images" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "image" varchar(255) NOT NULL,
            "position_id" integer NULL
          );""";
      const String sql3 = """
        CREATE TABLE IF NOT EXISTS "passe" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "munitionReference" varchar(255) NOT NULL,
            "profondeurSonde" integer NOT NULL,
            "gradientMag" integer NOT NULL,
            "profondeurSecurisee" integer NOT NULL,
            "coteSecurisee" integer NOT NULL,
            "prelevement" integer NULL
          );""";
      await SQLiteWrapper().execute(sql1);
      await SQLiteWrapper().execute(sql2);
      await SQLiteWrapper().execute(sql3);
    });
    */
    // Print where the database is stored
    debugPrint("Database path: ${dbInfo.path}");
  }

  closeDB() {
    SQLiteWrapper().closeDB();
  }

  /*DatabaseHelper()
                    .showPositions()
                    .then((value) => print("local ==> $value\n"));*/
}

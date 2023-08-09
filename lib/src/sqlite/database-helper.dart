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

    await SQLiteWrapper().openDB(dbPath, onCreate: () async {
      const String sql1 = """
        CREATE TABLE IF NOT EXISTS "parcelle" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "nom" varchar(255) NOT NULL,
            "type" varchar(255) NOT NULL,
            "geometry" varchar(255) NOT NULL,
            "fichierShp" varchar(255) NOT NULL,
            "fichierShx" varchar(255) NOT NULL,
            "fichierDbf" varchar(255) NOT NULL,
            "fichierPrj" varchar(255) NOT NULL
          );""";
      const String sql2 = """
        CREATE TABLE IF NOT EXISTS "plan_sondage" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "nom" varchar(255) NOT NULL,
            "type" varchar(255) NOT NULL,
            "latitude" double NOT NULL,
            "longitude" double NOT NULL,
            "fichierShp" varchar(255) NOT NULL,
            "fichierShx" varchar(255) NOT NULL,
            "fichierDbf" varchar(255) NOT NULL,
            "fichierPrj" varchar(255) NOT NULL,
            "baseRef" varchar(255) NOT NULL,
            "parcelle" integer NOT NULL
          );""";
      const String sql3 = """
        CREATE TABLE IF NOT EXISTS "securisation" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "nom" varchar(255) NOT NULL,
            "munitionReference" varchar(255) NOT NULL,
            "cotePlateforme" double NOT NULL,
            "profondeurASecuriser" double NOT NULL,
            "coteASecuriser" double NOT NULL,
            "parcelle" integer NOT NULL
          );""";
      const String sql4 = """
        CREATE TABLE IF NOT EXISTS "prelevement" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "numero" varchar(255) NOT NULL,
            "munitionReference" varchar(255) NOT NULL,
            "cotePlateforme" double NOT NULL,
            "profondeurASecuriser" double NOT NULL,
            "coteASecuriser" double NOT NULL,
            "statut" varchar(255) NULL,
            "remarques" varchar(255) NULL,
            "planSondage" integer NOT NULL
          );""";
      const String sql5 = """
        CREATE TABLE IF NOT EXISTS "passe" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "munitionReference" varchar(255) NOT NULL,
            "profondeurSonde" double NOT NULL,
            "gradientMag" double NOT NULL,
            "profondeurSecurisee" double NOT NULL,
            "coteSecurisee" double NOT NULL,
            "prelevement" integer NOT NULL
          );""";
      const String sql6 = """
        CREATE TABLE IF NOT EXISTS "images_prelevement" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "image" varchar(255) NOT NULL,
            "prelevement" integer NOT NULL
          );""";
      const String sql7 = """
        CREATE TABLE IF NOT EXISTS "observation" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "nom" varchar(255) NOT NULL,
            "description" integer NOT NULL,
            "latitude" varchar(255) NOT NULL,
            "longitude" varchar(255) NOT NULL,
            "parcelle" integer NOT NULL
          );""";
      const String sql8 = """
        CREATE TABLE IF NOT EXISTS "images_observation" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "image" varchar(255) NOT NULL,
            "observation" integer NOT NULL
          );""";
      const String sql9 = """
        CREATE TABLE IF NOT EXISTS "user" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "firstname" varchar(255) NOT NULL,
            "lastname" varchar(255) NOT NULL,
            "email" varchar(255) NOT NULL,
            "password" varchar(255) NOT NULL,
            "role_id" integer NOT NULL
          );""";
      const String sql10 = """
        CREATE TABLE IF NOT EXISTS "user_parcelle" (
            "user_id" integer NOT NULL,
            "parcelle_id" integer NOT NULL
          );""";
      const String sql11 = """
        CREATE TABLE IF NOT EXISTS "synchronisation" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "tableName" varchar(255) NOT NULL,
            "recordId" integer NOT NULL,
            "operation" varchar(255) NOT NULL,
            "data" varchar(255) NOT NULL,
            "syncStatus" integer NOT NULL
          );""";

      await SQLiteWrapper().execute(sql1);
      await SQLiteWrapper().execute(sql2);
      await SQLiteWrapper().execute(sql3);
      await SQLiteWrapper().execute(sql4);
      await SQLiteWrapper().execute(sql5);
      await SQLiteWrapper().execute(sql6);
      await SQLiteWrapper().execute(sql7);
      await SQLiteWrapper().execute(sql8);
      await SQLiteWrapper().execute(sql9);
      await SQLiteWrapper().execute(sql10);
      await SQLiteWrapper().execute(sql11);
    });

    //await DatabaseHelper().closeDB();
  }

  closeDB() {
    SQLiteWrapper().closeDB();
  }
}

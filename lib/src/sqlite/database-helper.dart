import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql1/mysql1.dart';
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

    // Step 1: Connect to MySQL
    final settings = ConnectionSettings(
      host: '${dotenv.env['HOST_NAME']}',
      port: int.parse(dotenv.env['PORT']!),
      user: '${dotenv.env['USER_NAME']}',
      password: '${dotenv.env['PASSWORD']}',
      db: '${dotenv.env['DATABASE_NAME']}',
      timeout: Duration(seconds: 30),
    );
    final conn = await MySqlConnection.connect(settings);

    // Step 2:  Create SQLite database
    final DatabaseInfo dbInfo =
        await SQLiteWrapper().openDB(dbPath, onCreate: () async {
      const String sql1 = """
        CREATE TABLE IF NOT EXISTS "parcelle" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "file" varchar(255) NOT NULL,
            "type" varchar(255) NOT NULL,
            "geometry" varchar(255) NOT NULL
          );""";
      const String sql2 = """
        CREATE TABLE IF NOT EXISTS "plan_sondage" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "file" varchar(255) NOT NULL,
            "type" varchar(255) NOT NULL,
            "geometry" varchar(255) NOT NULL,
            "base_ref" integer NOT NULL,
            "parcelle_id" integer NOT NULL
          );""";
      const String sql3 = """
        CREATE TABLE IF NOT EXISTS "securisation" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "nom" varchar(255) NOT NULL,
            "munition_reference" varchar(255) NOT NULL,
            "cote_plateforme" integer NOT NULL,
            "profondeurasecuriser" integer NOT NULL,
            "coteasecuriser" integer NOT NULL,
            "parcelle_id" integer NOT NULL
          );""";
      const String sql4 = """
        CREATE TABLE IF NOT EXISTS "prelevement" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "numero" integer NOT NULL,
            "munition_reference" varchar(255) NOT NULL,
            "cote_plateforme" integer NOT NULL,
            "profondeurasecuriser" integer NOT NULL,
            "coteasecuriser" integer NOT NULL,
            "plan_sondage_id" integer NOT NULL,
            "securisation_id" integer NOT NULL,
            "statut" varchar(255) NULL,
            "remarques" varchar(255) NULL
          );""";
      const String sql5 = """
        CREATE TABLE IF NOT EXISTS "passe" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "munition_reference" varchar(255) NOT NULL,
            "profondeur_sonde" integer NOT NULL,
            "gradient_mag" integer NOT NULL,
            "profondeur_securisee" integer NOT NULL,
            "cote_securisee" integer NOT NULL,
            "prelevement_id" integer NOT NULL
          );""";
      const String sql6 = """
        CREATE TABLE IF NOT EXISTS "images" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "image" varchar(255) NOT NULL,
            "prelevement_id" integer NOT NULL
          );""";
      const String sql7 = """
        CREATE TABLE IF NOT EXISTS "synchronisation" (
            "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
            "table_name" varchar(255) NOT NULL,
            "record_id" integer UNIQUE NOT NULL,
            "operation" varchar(255) NOT NULL,
            "data" varchar(255) NOT NULL,
            "sync_status" integer NOT NULL
          );""";
      await SQLiteWrapper().execute(sql1);
      await SQLiteWrapper().execute(sql2);
      await SQLiteWrapper().execute(sql3);
      await SQLiteWrapper().execute(sql4);
      await SQLiteWrapper().execute(sql5);
      await SQLiteWrapper().execute(sql6);
      await SQLiteWrapper().execute(sql7);
    });

    // Step 3: Fetch tables from Mysql
    final tableNamesResult = await conn.query('SHOW TABLES');
    final tableNames =
        tableNamesResult.map((r) => r.values?.first as String).toList();
    for (var tableName in tableNames) {
      switch (tableName) {
        case "images":
          print("images");
          final results = await conn.query('SELECT * FROM images');
          for (var row in results) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM images WHERE id = ?',
                params: [row['id']]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row['id'],
                'image': row['image'].toString(),
                'prelevement_id': row['prelevement_id'],
              }, "images");
            }
          }
          await SQLiteWrapper()
              .query("SELECT * FROM images")
              .then((value) => print("value => $value"));
          break;
        case "passe":
          print("passe");
          final results = await conn.query('SELECT * from passe');
          for (var row in results) {
            final existingRow = await SQLiteWrapper()
                .query('SELECT * FROM passe WHERE id = ?', params: [row['id']]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row['id'],
                'munition_reference': row['munition_reference'],
                'profondeur_sonde': row['profondeur_sonde'],
                'gradient_mag': row['gradient_mag'],
                'profondeur_securisee': row['profondeur_securisee'],
                'cote_securisee': row['cote_securisee'],
                'prelevement_id': row['prelevement_id'],
              }, "passe");
            }
          }
          break;
        case "prelevement":
          print("prelevement");
          final results = await conn.query('SELECT * from prelevement');
          for (var row in results) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM prelevement WHERE id = ?',
                params: [row['id']]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row['id'],
                'numero': row['numero'],
                'munition_reference': row['munition_reference'],
                'cote_plateforme': row['cote_plateforme'],
                'profondeurasecuriser': row['profondeurasecuriser'],
                'coteasecuriser': row['coteasecuriser'],
                'plan_sondage_id': row['plan_sondage_id'],
                'securisation_id': row['securisation_id'],
                'statut': row['statut'],
                'remarques': row['remarques']
              }, "prelevement");
            }
          }
          break;
        case "securisation":
          print("securisation");
          final results = await conn.query('SELECT * from securisation');
          for (var row in results) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM securisation WHERE id = ?',
                params: [row['id']]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row['id'],
                'nom': row['nom'],
                'munition_reference': row['munition_reference'],
                'cote_plateforme': row['cote_plateforme'],
                'profondeurasecuriser': row['profondeurasecuriser'],
                'coteasecuriser': row['coteasecuriser'],
                'parcelle_id': row['parcelle_id']
              }, "securisation");
            }
          }
          break;
        case "plan_sondage":
          print("plan_sondage");
          final results = await conn.query(
              'SELECT id, file, type, ST_AsText(geometry) as geometry, base_ref, parcelle_id from plan_sondage');
          for (var row in results) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM plan_sondage WHERE id = ?',
                params: [row['id']]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row['id'],
                'file': row['file'],
                'type': row['type'],
                'geometry': row['geometry'].toString(),
                'base_ref': row['base_ref'],
                'parcelle_id': row['parcelle_id']
              }, "plan_sondage");
            }
          }
          break;
        case "parcelle":
          print("parcelle");
          final results = await conn.query(
              'SELECT id, file, type, ST_AsText(geometry) as geometry from parcelle');
          for (var row in results) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM parcelle WHERE id = ?',
                params: [row['id']]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row['id'],
                'file': row['file'],
                'type': row['type'],
                'geometry': row['geometry'].toString()
              }, "parcelle");
            }
          }
          break;
        default:
      }
    }
    await conn.close();
    await DatabaseHelper().closeDB();
  }

  closeDB() {
    SQLiteWrapper().closeDB();
  }
}

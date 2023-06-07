import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mysql_client/mysql_client.dart';
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

    /*final settings = MySqlConnection.createConnection(
      host: '${dotenv.env['HOST_NAME']}',
      port: int.parse(dotenv.env['PORT']!),
      user: '${dotenv.env['USER_NAME']}',
      password: '${dotenv.env['PASSWORD']}',
      db: '${dotenv.env['DATABASE_NAME']}',
      timeout: Duration(seconds: 30),
    );
    final conn = await MySqlConnection.connect(settings);*/
    // Step 1: Connect to MySQL
    final conn = await MySQLConnection.createConnection(
      host: '${dotenv.env['HOST_NAME']}',
      port: int.parse(dotenv.env['PORT']!),
      userName: '${dotenv.env['USER_NAME']}',
      password: '${dotenv.env['PASSWORD']}',
      databaseName: '${dotenv.env['DATABASE_NAME']}',
    );
    await conn.connect();

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
    final tableNamesResult = await conn.execute('SHOW TABLES');
    final tableNames = tableNamesResult.rows
        .map((r) => r.assoc().values.first as String)
        .toList();
    for (var tableName in tableNames) {
      switch (tableName) {
        case "images":
          final results = await conn.execute('SELECT * FROM images');
          for (var row in results.rows) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM images WHERE id = ?',
                params: [row.colAt(0)]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row.colAt(0),
                'image': row.colAt(1).toString(),
                'prelevement_id': row.colAt(2),
              }, "images");
            }
          }
          /*await SQLiteWrapper()
              .query("SELECT * FROM images")
              .then((value) => print("value => $value"));*/
          break;
        case "passe":
          final results = await conn.execute('SELECT * from passe');
          for (var row in results.rows) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM passe WHERE id = ?',
                params: [row.colAt(0)]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row.colAt(0),
                'munition_reference': row.colAt(1),
                'profondeur_sonde': row.colAt(2),
                'gradient_mag': row.colAt(3),
                'profondeur_securisee': row.colAt(4),
                'cote_securisee': row.colAt(5),
                'prelevement_id': row.colAt(6),
              }, "passe");
            }
          }
          break;
        case "prelevement":
          final results = await conn.execute('SELECT * from prelevement');
          for (var row in results.rows) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM prelevement WHERE id = ?',
                params: [row.colAt(0)]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row.colAt(0),
                'numero': row.colAt(1),
                'munition_reference': row.colAt(2),
                'cote_plateforme': row.colAt(3),
                'profondeurasecuriser': row.colAt(4),
                'coteasecuriser': row.colAt(5),
                'plan_sondage_id': row.colAt(6),
                'securisation_id': row.colAt(7),
                'statut': row.colAt(8),
                'remarques': row.colAt(9)
              }, "prelevement");
            }
          }
          break;
        case "securisation":
          final results = await conn.execute('SELECT * from securisation');
          for (var row in results.rows) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM securisation WHERE id = ?',
                params: [row.colAt(0)]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row.colAt(0),
                'nom': row.colAt(1),
                'munition_reference': row.colAt(2),
                'cote_plateforme': row.colAt(3),
                'profondeurasecuriser': row.colAt(4),
                'coteasecuriser': row.colAt(5),
                'parcelle_id': row.colAt(6)
              }, "securisation");
            }
          }
          break;
        case "plan_sondage":
          final results = await conn.execute(
              'SELECT id, file, type, ST_AsText(geometry) as geometry, base_ref, parcelle_id from plan_sondage');
          for (var row in results.rows) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM plan_sondage WHERE id = ?',
                params: [row.colAt(0)]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row.colAt(0),
                'file': row.colAt(1),
                'type': row.colAt(2),
                'geometry': row.colAt(3).toString(),
                'base_ref': row.colAt(4),
                'parcelle_id': row.colAt(5)
              }, "plan_sondage");
            }
          }
          break;
        case "parcelle":
          final results = await conn.execute(
              'SELECT id, file, type, ST_AsText(geometry) as geometry from parcelle');
          for (var row in results.rows) {
            final existingRow = await SQLiteWrapper().query(
                'SELECT * FROM parcelle WHERE id = ?',
                params: [row.colAt(0)]);
            if (existingRow.isEmpty) {
              await SQLiteWrapper().insert({
                'id': row.colAt(0),
                'file': row.colAt(1),
                'type': row.colAt(2),
                'geometry': row.colAt(3).toString()
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

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SqlDb {
  /*static Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }*/

  initialDb() async {
    final docDir = await getApplicationDocumentsDirectory();
    if (!await docDir.exists()) {
      await docDir.create(recursive: true);
    }
    await SQLiteWrapper().openDB(p.join(docDir.path, "todoDatabase.sqlite"));
  }

  _onCreate(/*Database db, int version*/) async {
    const String sql = """
		CREATE TABLE IF NOT EXISTS "position" (
          "id" integer PRIMARY KEY AUTOINCREMENT NOT NULL,
          "addresse" varchar(255) NOT NULL,
          "description" varchar(255) NOT NULL,
          "latitude" varchar(255) NOT NULL,
          "longitude" varchar(255) NOT NULL
        );""";

    await SQLiteWrapper().execute(sql);
    /*await db.execute('''
    CREATE TABLE "position" (
      "id" INTEGER AUTOINCREMENT NOT NULL PRIMARY KEY , 
      "addresse" TEXT,
      "description" TEXT,
      "latitude" TEXT, 
      "longitude" TEXT)
    ''');
    print("Create database and table");*/
  }

  /* readData(String sql) async {
    Database? mydb = await db;
    List<Map> response = await mydb!.rawQuery(sql);
    return response;
    final Map? userMap = await sqlWrapper.query(sql, singleResult: true);
  }

  insertData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database? mydb = await db;
    int response = await mydb!.rawDelete(sql);
    return response;
  }*/
}

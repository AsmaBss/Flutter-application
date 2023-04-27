import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class PasseQuery {
  Future<List> showPasses() async {
    return await SQLiteWrapper().query("SELECT * FROM passe");
  }

  void addPasse(PasseModel p) async {
    await SQLiteWrapper().insert(p.toMap(), "passe");
    print("Data inserted in local !");
  }

  void deletePasse(int id) async {
    await SQLiteWrapper()
        .execute("DELETE FROM passe WHERE id = ?", params: [id]);
    print("Data deleted in local !");
  }

  void delete(PasseModel p) async {
    await SQLiteWrapper().delete(p.toMap(), "passe", keys: ["id"]);
    print("Data deleted in local !");
  }
}

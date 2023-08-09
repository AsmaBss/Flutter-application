import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class ParcelleQuery {
  Future<void> insertParcelles() async {
    await SQLiteWrapper().execute("DELETE FROM parcelle");
    List<ParcelleModel>? parcelles = await SqliteApi().getAllParcelles();
    for (final parcelle in parcelles!) {
      await SQLiteWrapper().insert(parcelle.toMap(), 'parcelle');
    }
    showParcelles().then((value) => print("parcelle : $value"));
  }

  Future<List<ParcelleModel>?> showParcelles() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM parcelle");
    final List<ParcelleModel> parcelles =
        result.map((row) => ParcelleModel.fromMap(row)).toList();
    return parcelles;
  }

  Future<ParcelleModel> showParcelleById(int id) async {
    final dynamic result = await SQLiteWrapper().query(
        "SELECT * FROM parcelle WHERE id = ?",
        params: [id],
        singleResult: true);

    final ParcelleModel list = ParcelleModel.fromMap(result);
    return list;
  }

  Future<List<ParcelleModel>?> showParcelleByUserId(int id) async {
    List<ParcelleModel>? list = [];
    final List<dynamic> result = await SQLiteWrapper().query(
        "SELECT parcelle_id FROM user_parcelle WHERE user_id = ?",
        params: [id]);
    for (var i in result) {
      ParcelleModel parcelle = await showParcelleById(i);
      list.add(parcelle);
    }
    return list;
  }
}

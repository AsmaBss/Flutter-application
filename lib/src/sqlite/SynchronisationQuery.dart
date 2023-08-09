import 'package:flutter_application/src/models/SynchronisationModel.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SynchronisationQuery {
  Future<List<SynchronisationModel>> showAllSynchronisations() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM synchronisation");
    final List<SynchronisationModel> list =
        result.map((row) => SynchronisationModel.fromJson(row)).toList();
    return list;
  }

  void deleteAllSynchronisations() {
    SQLiteWrapper().query("DELETE FROM synchronisation");
  }

  void insertSynchronisation(
      String tableName, int recordId, String operation, String data) async {
    await SQLiteWrapper().insert({
      "tableName": tableName,
      "recordId": recordId,
      "operation": operation,
      "data": data,
      "syncStatus": 0
    }, "synchronisation");
    showAllSynchronisations();
  }

  void deleteSynchronisation(
      String tableName, int recordId, String operation, String data) async {
    await SQLiteWrapper().execute(
        "UPDATE synchronisation SET operation = ?, data = ? WHERE tableName = ? AND recordId = ?",
        params: [operation, data, tableName, recordId]);
  }

  void updateSynchronisation(
      String tableName, int recordId, String operation, String data) async {
    await SQLiteWrapper().execute(
        "UPDATE synchronisation SET operation = ?, data = ? WHERE tableName = ? AND recordId = ?",
        params: [operation, data, tableName, recordId]);
    showAllSynchronisations();
  }
}

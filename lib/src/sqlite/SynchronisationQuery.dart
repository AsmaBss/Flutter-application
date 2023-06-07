import 'dart:convert';

import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SynchronisationQuery {
  Future<List> showAllSynchronisation() async {
    return await SQLiteWrapper().query("SELECT * FROM synchronisation");
  }

  // Save a change to the pending_changes table
  Future<void> saveChange(String operation, String tableName, int recordId,
      Map<String, dynamic>? data) async {
    final jsonData = data != null ? jsonEncode(data) : null;
    await SQLiteWrapper().query(
        "INSERT INTO pending_changes (operation, table_name, record_id, data)VALUES (?, ?, ?, ?)",
        params: [operation, tableName, recordId, jsonData]);
  }

  /*void saveDataToSQLite(Database db, int id, String field1, String field2) async {
  await db.insert(
    'your_table',
    {'id': id, 'field1': field1, 'field2': field2},
  );

  // Add the pending change to SQLite
  final sqliteConn = await db.rawQuery("PRAGMA database_list");
  final dbName = sqliteConn.first['name'];
  await db.rawInsert(
    "INSERT INTO $dbName.pending_changes (id, field1, field2) VALUES (?, ?, ?)",
    [id, field1, field2],
  );
}*/
}

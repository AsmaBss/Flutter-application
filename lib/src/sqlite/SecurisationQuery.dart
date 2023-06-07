import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SecurisationQuery {
  Future<List> showAllSecurisations() async {
    return await SQLiteWrapper().query("SELECT * FROM securisation");
  }

  void addSecurisation(SecurisationModel s) async {
    final id = await SQLiteWrapper().insert(s.toMap(), "securisation");
    await SynchronisationQuery().saveChange('insert', 'V', id, s.toMap());
    print("Data inserted in local !");
  }

  void deletePosition(SecurisationModel s) async {
    await SQLiteWrapper().delete(s.toMap(), "securisation", keys: ["id"]);
    print("Data deleted in local !");
  }

  void updatePosition(SecurisationModel s) async {
    await SQLiteWrapper().update(s.toMap(), "securisation", keys: ["id"]);
    print("Data updated in local !");
  }
}

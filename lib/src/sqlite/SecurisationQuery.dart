import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SecurisationQuery {
  Future<List> showAllSecurisations() async {
    return await SQLiteWrapper().query("SELECT * FROM securisation");
  }

  void addSecurisation(SecurisationModel s) async {
    await SQLiteWrapper().insert(s.toMap(), "securisation");
    print("Data inserted in local !");
  }
}

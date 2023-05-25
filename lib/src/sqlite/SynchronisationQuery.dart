import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class SynchronisationQuery {
  Future<List> showAllSynchronisation() async {
    return await SQLiteWrapper().query("SELECT * FROM synchronisation");
  }

  
  

}

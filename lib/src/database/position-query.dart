import 'package:flutter_application/src/models/position-model.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class PositionQuery {
  Future<List> showPositions() async {
    return await SQLiteWrapper().query("SELECT * FROM position");
  }

  Future<List> showPositionByLatAndLng(
      String latitude, String longitude) async {
    return await SQLiteWrapper().query(
        "SELECT * FROM position WHERE latitude = ? AND longitude = ?",
        params: [latitude, longitude]);
  }

/*
  Future<int> addPosition(String addresse, String description, String latitude,
      String longitude) async {
    return await SQLiteWrapper().insert(
        PositionModel(
                addresse: addresse,
                description: description,
                latitude: latitude,
                longitude: longitude)
            .toMap(),
        "position");
    //print("Data inserted in local !");
  }
*/
  void addPosition(PositionModel p) async {
    await SQLiteWrapper().insert(p.toMap(), "position");
    print("Data inserted in local !");
  }

  void deletePosition(PositionModel position) async {
    await SQLiteWrapper().delete(position.toMap(), "position", keys: ["id"]);
    print("Data deleted in local !");
  }

  void updatePosition(PositionModel position) async {
    await SQLiteWrapper().update(position.toMap(), "position", keys: ["id"]);
    print("Data updated in local !");
  }

  Future<List> showPositionDistinctLatAndLng(
      String latitude, String longitude) async {
    return await SQLiteWrapper().query(
        "SELECT DISTINCT latitude, longitude FROM position WHERE latitude = ? AND longitude = ?",
        params: [latitude, longitude]);
  }
}

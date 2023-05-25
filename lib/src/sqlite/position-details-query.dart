import 'package:flutter_application/src/models/position-details-model.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class PositionDetailsQuery {
  Future<List> showPositionsDetails() async {
    return await SQLiteWrapper().query("SELECT * FROM position_details");
  }

  void addPositionDetails(int? id, String image) async {
    await SQLiteWrapper().insert(
        PositionDetailsModel(image: image, position_id: id).toMap(),
        "position_details");
    print("Data inserted in local !");
  }

  void deletePositionDetails(int id) async {
    await SQLiteWrapper()
        .execute("DELETE FROM position_details WHERE id = ?", params: [id]);
    /*await SQLiteWrapper()
        .delete(positionDetails.toMap(), "position_details", keys: ["id"]);*/
    print("Data deleted in local !");
  }

  Future<List> showPositionDetailsByPositionId(int idPos) async {
    return await SQLiteWrapper().query(
        "SELECT * FROM position_details WHERE position_id = ?",
        params: [idPos]);
  }

  Future<List> showPositionByLatAndLng(
      String latitude, String longitude) async {
    return await SQLiteWrapper().query(
        "SELECT * FROM position_details WHERE latitude = ? AND longitude = ?",
        params: [latitude, longitude]);
  }

  void truncateTable() async {
    await SQLiteWrapper().execute("DELETE FROM position_details");
  }
}

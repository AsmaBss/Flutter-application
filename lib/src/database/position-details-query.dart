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

  void deletePositionDetails(PositionDetailsModel positiondet) async {
    await SQLiteWrapper()
        .delete(positiondet.toMap(), "position_details", keys: ["id"]);
    print("Data deleted in local !");
  }

  void updatePositionDetails(PositionDetailsModel positiondet) async {
    await SQLiteWrapper()
        .update(positiondet.toMap(), "position_details", keys: ["id"]);
    print("Data updated in local !");
  }
}

import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/sqlite/sqlite-api.dart';
import 'package:sqlite_wrapper/sqlite_wrapper.dart';

class PlanSondageQuery {
  Future<void> insertPlanSondage() async {
    await SQLiteWrapper().execute("DELETE FROM plan_sondage");
    List<PlanSondageModel>? planSondages =
        await SqliteApi().getAllPlansSondage();
    for (final sondage in planSondages!) {
      await SQLiteWrapper().insert(sondage.toMap(), 'plan_sondage');
    }
    showPlanSondage().then((value) => print("plan_sondage : $value"));
  }

  Future<List<PlanSondageModel>?> showPlanSondage() async {
    final List<dynamic> result =
        await SQLiteWrapper().query("SELECT * FROM plan_sondage");
    final List<PlanSondageModel> list =
        result.map((row) => PlanSondageModel.fromMap(row)).toList();
    return list;
  }

  Future<List<PlanSondageModel>?> showPlanSondageByParcelleId(
      int parcelleId) async {
    final List<dynamic> result = await SQLiteWrapper().query(
      "SELECT * FROM plan_sondage where parcelle = ?",
      params: [parcelleId],
    );
    final List<PlanSondageModel> list =
        result.map((row) => PlanSondageModel.fromMap(row)).toList();
    return list;
  }

  Future<PlanSondageModel?> showPlanSondageByCoords(String coord) async {
    final dynamic result = await SQLiteWrapper().query(
        "SELECT * FROM plan_sondage where geometry = ? ",
        params: [coord],
        singleResult: true);
    final PlanSondageModel list = PlanSondageModel.fromMap(result);
    return list;
  }

  Future<int> nbrPlanSondageByParcelleId(int parcelleId) async {
    return await SQLiteWrapper().query(
        "SELECT count(*) FROM plan_sondage WHERE parcelle = ?",
        params: [parcelleId],
        singleResult: true);
  }
}

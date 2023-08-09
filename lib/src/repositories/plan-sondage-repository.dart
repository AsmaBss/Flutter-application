import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/sqlite/plan-sondage-query.dart';
import 'package:http/http.dart' as http;

class PlanSondageRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<PlanSondageModel>?> getByParcelle(
      int id, BuildContext context) async {
    //try {
    http.Response response =
        await _apiServices.get("/PlanSondage/show/parcelle/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = json.decode(response.body);
      final planSondageData = responseJson as List;
      List<PlanSondageModel> planSondagesList = planSondageData
          .map((json) => PlanSondageModel.fromJson(json))
          .toList();
      return planSondagesList;
    } else {
      return await PlanSondageQuery().showPlanSondageByParcelleId(id);
    }
    /*} on Exception catch (e) {
      throw Exception(e.toString());
    }*/
  }

  Future<int?> nbrByParcelle(int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.get("/PlanSondage/show/nbr/$id");
      if (response.statusCode == 200) {
        int count = int.parse(response.body);
        return count;
      } else {
        return await PlanSondageQuery().nbrPlanSondageByParcelleId(id);
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}

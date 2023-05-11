import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:http/http.dart' as http;

class PlanSondageRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List> getAllPlanSondages(BuildContext context) async {
    http.Response response = await _apiServices.get("/PlanSondage/show");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final planSondageData = responseJson as List;
      List<PlanSondageModel> planSondagesList = planSondageData
          .map((json) => PlanSondageModel.fromJson(json))
          .toList();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server success : ${response.statusCode}"),
      ));
      return planSondagesList;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all planSondages !");
  }

  Future<PlanSondageModel> getPlanSondageById(
      int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/PlanSondage/show/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final planSondagesData = responseJson;
      PlanSondageModel planSondage = planSondagesData
          .map((json) => PlanSondageModel.fromJson(json))
          .toList();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server success : ${response.statusCode}"),
      ));
      return planSondage;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get planSondage !");
  }

  Future<List<PlanSondageModel>> getPlanSondageByParcelle(int id) async {
    http.Response response =
        await _apiServices.get("/PlanSondage/show/parcelle/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final planSondageData = responseJson as List;
      List<PlanSondageModel> planSondagesList = planSondageData
          .map((json) => PlanSondageModel.fromJson(json))
          .toList();

      return planSondagesList;
    } else {}
    throw Exception("Failed get all planSondages !");
  }

  Future<PlanSondageModel> getByCoords(
      String point, BuildContext context) async {
    http.Response response =
        await _apiServices.get("/PlanSondage/show/coordinates/$point");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final planSondagesData = responseJson;
      PlanSondageModel planSondage =
          PlanSondageModel.fromJson(planSondagesData);
      return planSondage;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get planSondage !");
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/database/position-details-query.dart';
import 'package:flutter_application/src/models/position-details-model.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/screens/my-alert-dialog.dart';
import 'package:http/http.dart' as http;

class PositionDetailsRepository {
  final ApiServices _apiServices = ApiServices();

  Future<Map<String, dynamic>> getAllPositionDetails() async {
    http.Response response =
        await _apiServices.get("/PositionDetails/show"); // ,params
    dynamic responseJson = jsonDecode(response.body);
    final positionsDetailsData = responseJson as List;
    List<PositionDetailsModel> positionsDetailsList = positionsDetailsData
        .map((json) => PositionDetailsModel.fromJson(json))
        .toList();
    return {
      "positions details list": positionsDetailsList,
    };
  }

  void addPositionDetails(
      PositionDetailsModel pd, PositionModel p, BuildContext context) async {
    http.Response response =
        await _apiServices.post("/PositionDetails/add/${p.id}", pd.toJson(pd));
    if (response.statusCode == 200) {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
              title: 'Server Response', content: response.body);
        },
      );
    } else {
      PositionDetailsQuery().addPositionDetails(p.id, pd.image.toString());
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Server Response',
            content: 'Problème au niveau de serveur : ${response.statusCode}',
          );
        },
      );
    }
  }

  Future<PositionDetailsModel> editPositionDetails(
      PositionDetailsModel p) async {
    http.Response response =
        await _apiServices.put("/PositionDetails/edit", p.toJson(p));
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return PositionDetailsModel.fromJson(jsonData);
  }

  void deletePosition(PositionDetailsModel p) async {
    http.Response response =
        await _apiServices.delete("/PositionDetails/delete/${p.id}");
    dynamic responseJson = jsonDecode(response.body);
    final jsonMessage = responseJson;
    print(jsonMessage);
  }

  Future<PositionDetailsModel> getPositionDetailsById(
      PositionDetailsModel p) async {
    http.Response response =
        await _apiServices.get("/PositionDetails/show/${p.id}");
    dynamic responseJson = jsonDecode(response.body);
    final positionDetailsData = responseJson;
    return positionDetailsData;
  }
}

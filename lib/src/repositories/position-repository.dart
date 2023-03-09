import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/database/position-query.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:flutter_application/src/widget/my-alert-dialog.dart';
import 'package:http/http.dart' as http;

class PositionRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List> getAllPositions(BuildContext context) async {
    http.Response response = await _apiServices.get("/Position/show");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final positionsData = responseJson as List;
      List<PositionModel> positionsList =
          positionsData.map((json) => PositionModel.fromJson(json)).toList();
      return positionsList;
    } else {
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
    throw Exception("Failed get all positions !");
  }

  void addPosition(PositionModel p, BuildContext context) async {
    http.Response response =
        await _apiServices.post("/Position/add", p.toJson(p));
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
      PositionQuery().addPosition(p);
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Server Response',
            content: 'Problem to connect the server : ${response.statusCode}',
          );
        },
      );
    }
  }

  /*Future<PositionModel> addPosition(PositionModel p) async {
    http.Response response =
        await _apiServices.post("/Position/add-position", p.toJson(p));
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return PositionModel.fromJson(jsonData);
  }*/

  Future<PositionModel> editPosition(PositionModel p) async {
    http.Response response =
        await _apiServices.put("/Position/edit", p.toJson(p));
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return PositionModel.fromJson(jsonData);
  }

  void deletePosition(PositionModel p, BuildContext context) async {
    int id = int.parse(p.id.toString());
    http.Response response = await _apiServices.delete("/Position/delete/$id");
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
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Server Response',
            content: 'Problem to connect the server : ${response.statusCode}',
          );
        },
      );
    }
  }

  /*void deletePosition(PositionModel p) async {
    http.Response response =
        await _apiServices.delete("/Position/delete/${p.id}");
    dynamic responseJson = jsonDecode(response.body);
    final jsonMessage = responseJson;
    print(jsonMessage);
  }*/

  Future<PositionModel> getPositionByLatAndLong(
      String latitude, String longitude, BuildContext context) async {
    http.Response response = await _apiServices
        .get("/Position/show-by-LatLong/$latitude/$longitude");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final jsonData = responseJson;
      return PositionModel.fromJson(jsonData);
    } else {
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext dialogContext) {
          return MyAlertDialog(
            title: 'Server Response',
            content: 'Problem to connect the server : ${response.statusCode}',
          );
        },
      );
    }
    throw Exception("Failed get position by lat and long !");
  }
}

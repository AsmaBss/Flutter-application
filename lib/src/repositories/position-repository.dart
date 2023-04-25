import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/database/position-query.dart';
import 'package:flutter_application/src/models/position-model.dart';
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server success : ${response.statusCode}"),
      ));
      return positionsList;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all positions !");
  }

  Future<PositionModel> getPositionById(int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/Position/show/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final positionsData = responseJson;
      PositionModel position =
          positionsData.map((json) => PositionModel.fromJson(json)).toList();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server success : ${response.statusCode}"),
      ));
      return position;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all positions !");
  }

  void addPosition(PositionModel p, List imgs, BuildContext context) async {
    http.Response response = await _apiServices.post("/Position/add", {
      "position": {
        "latitude": p.latitude,
        "longitude": p.longitude,
        "address": p.address,
        "description": p.description
      },
      "images": imgs
    });
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: Text(response.body),
          ))
          .closed
          .then((value) => Navigator.pop(context));
    } else {
      PositionQuery().addPosition(p);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error position: ${response.statusCode}"),
      ));
    }
  }

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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.body),
      ));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
  }

  Future<PositionModel?> getPositionByLatAndLong(
      String latitude, String longitude, BuildContext context) async {
    http.Response response =
        await _apiServices.get("/Position/show-LatLong/$latitude/$longitude");
    print("statuscode = ${response.statusCode}");
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return null;
      } else {
        dynamic responseJson = jsonDecode(response.body);
        final jsonData = responseJson;
        return PositionModel.fromJson(jsonData);
      }
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get position by lat and long !");
  }
}

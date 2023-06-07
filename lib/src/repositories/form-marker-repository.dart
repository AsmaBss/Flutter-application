import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/form-marker-model.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:http/http.dart' as http;

class FormMarkerRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List> getAllFormMarkers(BuildContext context) async {
    http.Response response = await _apiServices.get("/FormMarker/show");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final formMarkerData = responseJson as List;
      List<FormMarkerModel> formMarkerList =
          formMarkerData.map((json) => FormMarkerModel.fromJson(json)).toList();
      return formMarkerList;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all formMarkers !");
  }

  void addFormMarker(List imgs, FormMarkerModel fm, PositionModel p,
      BuildContext context) async {
    http.Response response =
        await _apiServices.post("/FormMarker/add/${p.id}", {
      "formMarker": {"description": fm.description, "numero": fm.numero},
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
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
  }

  Future<List> getByPositionId(int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/FormMarker/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final formMarkerData = responseJson as List;
      List<FormMarkerModel> formMarkerList =
          formMarkerData.map((json) => FormMarkerModel.fromJson(json)).toList();
      return formMarkerList;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get formMarkers By PositionID !");
  }
}

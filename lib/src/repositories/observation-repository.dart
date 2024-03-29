import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/sqlite/observation-query.dart';
import 'package:http/http.dart' as http;

class ObservationRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<ObservationModel>?> getAllObservations(
      int id, BuildContext context) async {
    //try {
    http.Response response =
        await _apiServices.get("/Observation/show/parcelle/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      List<dynamic> observationsData =
          responseJson is List ? responseJson : [responseJson];
      List<ObservationModel> observationsList = observationsData
          .map((json) => ObservationModel.fromJson(json))
          .toList();
      return observationsList;
    } else {
      return await ObservationQuery().showObservationByParcelleId(id);
    }
    /*} on Exception catch (e) {
      throw Exception(e.toString());
    }*/
  }

  Future<ObservationModel?> getByLatLng(
      String latitude, String longitude, BuildContext context) async {
    try {
      http.Response response = await _apiServices
          .get("/Observation/show/lat/$latitude/lng/$longitude");
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null;
        } else {
          dynamic responseJson = jsonDecode(response.body);
          final observationData = responseJson;
          return ObservationModel.fromJson(observationData);
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Problème au niveau de serveur: ${response.statusCode}"),
        ));
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  void addObservation(
    BuildContext context,
    ObservationModel s,
    ParcelleModel p,
    List<ImagesObservationModel> images,
  ) async {
    http.Response response = await _apiServices.post("/Observation/add", {
      "observation": {
        'nom': s.nom,
        'description': s.description,
        'latitude': s.latitude,
        'longitude': s.longitude,
      },
      "parcelle": p.toJson(p),
      "images": images.map((image) => image.toJson(image)).toList(),
    });
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.body}"),
      ));
    }
  }

  void updateObservation(BuildContext context, ObservationModel s,
      List<ImagesObservationModel> images) async {
    http.Response response = await _apiServices.put("/Observation/update", {
      "observation": s.toJson(s),
      "images": images.map((image) => image.toJson(image)).toList(),
    });
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.body}"),
      ));
    }
  }

  Future<void> deleteObservation(int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.delete("/Observation/delete/$id");
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Problème au niveau de serveur: ${response.statusCode}"),
        ));
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:http/http.dart' as http;

class ObservationRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<ObservationModel>> getAllObservations(
      int id, BuildContext context) async {
    try {
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
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Problème au niveau de serveur: ${response.statusCode}"),
        ));
      }
    } catch (e) {
      print('Erreur: $e');
    }
    throw Exception("Echec !");
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
}

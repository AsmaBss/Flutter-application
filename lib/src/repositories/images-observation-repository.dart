import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:http/http.dart' as http;

class ImagesObservationRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<ImagesObservationModel>> getImagesByObservation(
      int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.get("/ImagesObservations/show/$id");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final imagesData = responseJson as List;
        List<ImagesObservationModel> images = imagesData
            .map((json) => ImagesObservationModel.fromJson(json))
            .toList();
        return images;
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
}

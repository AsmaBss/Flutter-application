import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/ImageModel.dart';
import 'package:http/http.dart' as http;

class ImagesPrelevementRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<ImageModel>?> getImagesByPrelevement(
      int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.get("/Images/show/prelevement/$id");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final imagesData = responseJson as List;
        List<ImageModel> images =
            imagesData.map((json) => ImageModel.fromJson(json)).toList();
        return images;
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

  Future<void> deleteImage(int id, BuildContext context) async {
    await _apiServices
        .delete("/Images/delete/$id")
        .then((value) => Navigator.pop(context));
  }
}

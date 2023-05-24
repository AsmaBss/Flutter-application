import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/images-model.dart';
import 'package:http/http.dart' as http;

class ImagesRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<ImagesModel>> getImagesByPrelevement(
      int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.get("/Images/show/prelevement/$id");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final imagesData = responseJson as List;
        List<ImagesModel> images =
            imagesData.map((json) => ImagesModel.fromJson(json)).toList();
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

  addImage(ImagesModel img, int id, BuildContext context) async {
    await _apiServices.post("/Images/add/$id", img.toJson(img));
  }

  Future<ImagesModel> editImages(ImagesModel i) async {
    http.Response response =
        await _apiServices.put("/Images/edit", i.toJson(i));
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return ImagesModel.fromJson(jsonData);
  }

  deleteImage(int id, BuildContext context) async {
    await _apiServices
        .delete("/Images/delete/$id")
        .then((value) => Navigator.pop(context));
  }

  /*void deleteImages(int id, BuildContext context) async {
    http.Response response = await _apiServices.delete("/Images/delete/$id");
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
  }*/

  Future<List> getFormMarkerById(int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/Images/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final imagesData = responseJson as List;
      List<ImagesModel> imagesList =
          imagesData.map((json) => ImagesModel.fromJson(json)).toList();
      return imagesList;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get images by FormMarker !");
  }
}

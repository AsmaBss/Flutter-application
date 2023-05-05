import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/images-model.dart';
import 'package:http/http.dart' as http;

class ImagesRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List> getAllImages(BuildContext context) async {
    http.Response response = await _apiServices.get("/Images/show");
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
    throw Exception("Failed get all images !");
  }

  Future<ImagesModel> getImagesByPositionId(
      int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/Images/show/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final imagesData = responseJson;
      ImagesModel images =
          imagesData.map((json) => ImagesModel.fromJson(json)).toList();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server success : ${response.statusCode}"),
      ));
      return images;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all images !");
  }

  Future<List<ImagesModel>> getByPrelevement(
      int id, BuildContext context) async {
    http.Response response =
        await _apiServices.get("/Images/show/prelevement/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final imagesData = responseJson as List;
      List<ImagesModel> images =
          imagesData.map((json) => ImagesModel.fromJson(json)).toList();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server success : ${response.statusCode}"),
      ));
      print('images => $images');
      return images;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all images !");
  }

  void addImages(ImagesModel img, BuildContext context) async {
    http.Response response =
        await _apiServices.post("/Images/add", img.toJson(img));
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.body),
      ));
    } else {
      print(response.body);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error image: ${response.body}"),
      ));
    }
  }

  /*void addImages(
      ImagesModel img, FormMarkerModel fm, BuildContext context) async {
    http.Response response =
        await _apiServices.post("/FormMarker/add/${fm.id}", img.toJson(img));
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

  Future<ImagesModel> editImages(ImagesModel i) async {
    http.Response response =
        await _apiServices.put("/Images/edit", i.toJson(i));
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return ImagesModel.fromJson(jsonData);
  }

  void deleteImages(int id, BuildContext context) async {
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
  }

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

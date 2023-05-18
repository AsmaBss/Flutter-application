import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:http/http.dart' as http;

class PasseRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<PasseModel>> getByPrelevement(
      int id, BuildContext context) async {
    http.Response response =
        await _apiServices.get("/Passe/show/prelevement/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final passesData = responseJson as List;
      List<PasseModel> passes =
          passesData.map((json) => PasseModel.fromJson(json)).toList();

      return passes;
    } else {
      //
    }
    throw Exception("Failed get all passes !");
  }

  void addPasse(PasseModel p, int id, BuildContext context) async {
    http.Response response =
        await _apiServices.post("/Passe/add/$id", p.toJson(p));
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

  void updatePasse(PasseModel p, int id, BuildContext context) async {
    await _apiServices
        .put("/Passe/update/$id", p.toJson(p))
        .then((value) => Navigator.pop(context));
  }

  deletePasse(int id, BuildContext context) async {
    await _apiServices
        .delete("/Passe/delete/$id")
        .then((value) => Navigator.pop(context));
  }
}

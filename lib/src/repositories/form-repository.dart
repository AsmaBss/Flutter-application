import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/form-model.dart';
import 'package:http/http.dart' as http;

class FormRepository {
  final ApiServices _apiServices = ApiServices();

  Future<FormModel?> getById(int id, BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Form/show/$id");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final observationData = responseJson;
        return FormModel.fromJson(observationData);
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
}

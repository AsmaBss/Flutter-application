import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/sqlite/parcelle-query.dart';
import 'package:http/http.dart' as http;

class ParcelleRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<ParcelleModel>?> getAllParcelles() async {
    try {
      http.Response response = await _apiServices.get("/Parcelle/show");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final parcellesData =
            responseJson as List; //? responseJson : [responseJson];
        List<ParcelleModel> parcellesList =
            parcellesData.map((json) => ParcelleModel.fromJson(json)).toList();
        return parcellesList;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ParcelleModel>?> getByUser(int id, BuildContext context) async {
    //try {
    http.Response response = await _apiServices.get("/Parcelle/show/user/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      List<dynamic> parcellesData =
          responseJson is List ? responseJson : [responseJson];
      List<ParcelleModel> parcellesList =
          parcellesData.map((json) => ParcelleModel.fromJson(json)).toList();
      return parcellesList;
    } else {
      return await ParcelleQuery().showParcelleByUserId(id);
    }
    /*} catch (e) {
      print('Erreur: $e');
    }
    throw Exception("Echec !");*/
  }
}

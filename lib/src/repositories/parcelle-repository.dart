import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:http/http.dart' as http;

class ParcelleRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<ParcelleModel>> getAllParcelles(BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Parcelle/show");
      print("status => ${response.statusCode}");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        List<dynamic> parcellesData =
            responseJson is List ? responseJson : [responseJson];
        List<ParcelleModel> parcellesList =
            parcellesData.map((json) => ParcelleModel.fromJson(json)).toList();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server success : ${response.statusCode}"),
        ));
        return parcellesList;
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server error : ${response.statusCode}"),
        ));
      }
    } catch (e) {
      print('Error fetching parcelles: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to fetch parcelles: $e"),
      ));
    }
    throw Exception("Failed get all parcelles !");
  }

  Future<ParcelleModel> getParcelleById(int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/Parcelle/show/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final parcelleData = responseJson;
      ParcelleModel parcelle =
          parcelleData.map((json) => ParcelleModel.fromJson(json)).toList();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server success : ${response.statusCode}"),
      ));
      return parcelle;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all parcelle !");
  }
}

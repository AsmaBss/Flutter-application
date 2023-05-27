import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:http/http.dart' as http;

class ParcelleRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<ParcelleModel>> getAllParcelles(BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Parcelle/show");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        List<dynamic> parcellesData =
            responseJson is List ? responseJson : [responseJson];
        List<ParcelleModel> parcellesList =
            parcellesData.map((json) => ParcelleModel.fromJson(json)).toList();
        return parcellesList;
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

  Future<ParcelleModel> getParcelleById(int id, BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Parcelle/show/$id");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final parcelleData = responseJson;
        ParcelleModel parcelle = ParcelleModel.fromJson(parcelleData);
        return parcelle;
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

  Future<ParcelleModel> getSecurisation(int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.get("/Parcelle/show/securisation/$id");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final parcelleData = responseJson;
        return ParcelleModel.fromJson(parcelleData);
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

  Future<List> getCoordinates(int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.get("/Parcelle/show/coordinates/$id");
      print("code = ${response.statusCode}");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final data = responseJson as List;
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server success : ${response.statusCode}"),
        ));
        return data;
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

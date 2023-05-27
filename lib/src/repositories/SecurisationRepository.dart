import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:http/http.dart' as http;

class SecurisationRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<SecurisationModel>> getAllSecurisations(
      BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Securisation/show");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        List<dynamic> securisationsData =
            responseJson is List ? responseJson : [responseJson];
        List<SecurisationModel> securisationsList = securisationsData
            .map((json) => SecurisationModel.fromJson(json))
            .toList();
        return securisationsList;
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

  Future<SecurisationModel> getSecurisationById(
      int id, BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Securisation/show/$id");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final securisationData = responseJson;
        SecurisationModel securisation = securisationData
            .map((json) => SecurisationModel.fromJson(json))
            .toList();
        return securisation;
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

  Future<SecurisationModel> addSecurisation(
      BuildContext context, SecurisationModel s, ParcelleModel p) async {
    http.Response response = await _apiServices.post("/Securisation/add", {
      "securisation": {
        'nom': s.nom,
        'munitionReference': s.munitionReference,
        'cotePlateforme': s.cotePlateforme,
        'profondeurASecuriser': s.profondeurASecuriser,
        'coteASecuriser': s.coteASecuriser,
      },
      "parcelle": p.toJson(p)
    });
    return SecurisationModel.fromJson(jsonDecode(response.body));
  }

  void updateSecurisation(
      BuildContext context, SecurisationModel s, int id) async {
    try {
      http.Response response =
          await _apiServices.put("/Securisation/update/$id", s.toJson(s));
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.pop(context, true);
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
    //throw Exception("Echec !");
  }

  deleteSecurisation(int id, BuildContext context) async {
    try {
      await _apiServices
          .delete("/Securisation/delete/$id")
          .then((value) => Navigator.pop(context))
          .catchError((error) {});
    } catch (e) {
      print('Erreur: $e');
    }
  }
}

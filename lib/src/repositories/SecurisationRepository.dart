import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:http/http.dart' as http;

class SecurisationRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<SecurisationModel>> getAllSecurisations(
      BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Securisation/show");
      print("status => ${response.statusCode}");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        List<dynamic> securisationsData =
            responseJson is List ? responseJson : [responseJson];
        List<SecurisationModel> securisationsList = securisationsData
            .map((json) => SecurisationModel.fromJson(json))
            .toList();
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server success : ${response.statusCode}"),
        ));
        return securisationsList;
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Server error : ${response.statusCode}"),
        ));
      }
    } catch (e) {
      print('Error fetching Securisation: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to fetch Securisation: $e"),
      ));
    }
    throw Exception("Failed get all Securisation !");
  }

  Future<SecurisationModel> getSecurisationById(
      int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/Securisation/show/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final securisationData = responseJson;
      SecurisationModel securisation = securisationData
          .map((json) => SecurisationModel.fromJson(json))
          .toList();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server success : ${response.statusCode}"),
      ));
      return securisation;
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all Securisation !");
  }

  Future<int> addSecurisationParcelle(
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
    return int.parse(response.body);
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
}

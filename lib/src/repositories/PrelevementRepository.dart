import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/images-model.dart';
import 'package:http/http.dart' as http;

class PrelevementRepository {
  final ApiServices _apiServices = ApiServices();

  Future<List<PrelevementModel>> getAllSecurisations(
      BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Securisation/show");
      print("status => ${response.statusCode}");
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        List<dynamic> securisationsData =
            responseJson is List ? responseJson : [responseJson];
        List<PrelevementModel> securisationsList = securisationsData
            .map((json) => PrelevementModel.fromJson(json))
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

  Future<PrelevementModel> getSecurisationById(
      int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/Securisation/show/$id");
    if (response.statusCode == 200) {
      dynamic responseJson = jsonDecode(response.body);
      final securisationData = responseJson;
      PrelevementModel securisation = securisationData
          .map((json) => PrelevementModel.fromJson(json))
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

  void addPrelevement(
      BuildContext context,
      PrelevementModel s,
      List passes,
      List images,
      SecurisationModel securisation,
      PlanSondageModel planSondage) async {
    print("passes => $passes");
    http.Response response = await _apiServices.post("/Prelevement/add", {
      "prelevement": {
        'numero': s.numero,
        'munitionReference': s.munitionReference,
        'cotePlateforme': s.cotePlateforme,
        'profondeurASecuriser': s.profondeurASecuriser,
        'coteASecuriser': s.coteASecuriser,
        'remarques': s.remarques,
        'statut': s.statut
      },
      "passes": passes,
      "images": images,
      "planSondage": planSondage.toJson(planSondage),
      "securisation": securisation.toJson(securisation)
    });
    print(response.statusCode);
    if (response.statusCode == 200) {
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
}

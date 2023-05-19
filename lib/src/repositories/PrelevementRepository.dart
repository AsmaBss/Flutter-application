import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/database/images-query.dart';
import 'package:flutter_application/src/database/passe-query.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/images-model.dart';
import 'package:http/http.dart' as http;

class PrelevementRepository {
  final ApiServices _apiServices = ApiServices();

  Future<PrelevementModel?> getPrelevementByPlanSondage(
      String coord, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.get("/Prelevement/show/$coord");
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null;
        } else {
          dynamic responseJson = jsonDecode(response.body);
          final prelevementData = responseJson;
          return PrelevementModel.fromJson(prelevementData);
        }
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

  Future<PrelevementModel?> getPrelevementByPlanSondageId(
      int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.get("/Prelevement/show/sondage/$id");
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return null;
        } else {
          dynamic responseJson = jsonDecode(response.body);
          final prelevementData = responseJson;
          return PrelevementModel.fromJson(prelevementData);
        }
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

  void addPrelevement(
      BuildContext context,
      PrelevementModel s,
      List<PasseModel> passes,
      List<ImagesModel> images,
      SecurisationModel securisation,
      PlanSondageModel planSondage) async {
    print("passes => ${passes.runtimeType}");
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
      'passes': passes.map((passe) => passe.toJson(passe)).toList(),
      'images': images.map((image) => image.toJson(image)).toList(),
      "planSondage": planSondage.toJson(planSondage),
      "securisation": securisation.toJson(securisation)
    });
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.body}"),
      ));
    }
  }

  void updatePrelevement(
      BuildContext context, PrelevementModel p, int id) async {
    try {
      http.Response response =
          await _apiServices.put("/Prelevement/update/$id", p.toJson(p));
      if (response.statusCode == 200) {
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
  }

  Future<int> nbrBySecurisation(int id, BuildContext context) async {
    try {
      http.Response response = await _apiServices.get("/Prelevement/count/$id");
      if (response.statusCode == 200) {
        int count = int.parse(response.body);
        return count;
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

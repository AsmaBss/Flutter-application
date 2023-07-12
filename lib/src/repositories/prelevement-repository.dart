import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/ImageModel.dart';
import 'package:http/http.dart' as http;

class PrelevementRepository {
  final ApiServices _apiServices = ApiServices();

  Future<PrelevementModel?> getByPlanSondage(
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
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<PrelevementModel?> getByPlanSondageId(
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
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<int?> nbrBySecurisation(int id, BuildContext context) async {
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
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  void addPrelevement(
      BuildContext context,
      PrelevementModel s,
      List<PasseModel> passes,
      List<ImageModel> images,
      SecurisationModel securisation,
      PlanSondageModel planSondage) async {
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
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.body}"),
      ));
    }
  }

  void updatePrelevement(BuildContext context, PrelevementModel p,
      List<ImageModel> images, List<PasseModel> passes, int id) async {
    try {
      http.Response response =
          await _apiServices.put("/Prelevement/update/$id", {
        'prelevement': p.toJson(p),
        'images': images.map((image) => image.toJson(image)).toList(),
        'passes': passes.map((passes) => passes.toJson(passes)).toList(),
      });
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
  }

  Future<void> deletePrelevement(int id, BuildContext context) async {
    try {
      http.Response response =
          await _apiServices.delete("/Prelevement/delete/$id");
      if (response.statusCode == 200) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Problème au niveau de serveur: ${response.statusCode}"),
        ));
      }
      //.then((value) => Navigator.pop(context));
    } catch (e) {
      print('Erreur: $e');
    }
  }
}

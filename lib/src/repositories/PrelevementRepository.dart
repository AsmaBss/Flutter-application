import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/database/images-query.dart';
import 'package:flutter_application/src/database/passe-query.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:http/http.dart' as http;

class PrelevementRepository {
  final ApiServices _apiServices = ApiServices();

  Future<PrelevementModel?> getPrelevementByPlanSondage(
      String coord, BuildContext context) async {
    http.Response response = await _apiServices.get("/Prelevement/show/$coord");
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
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all Prelevement !");
  }

  Future<PrelevementModel?> getPrelevementByPlanSondageId(
      int id, BuildContext context) async {
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
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
    throw Exception("Failed get all Prelevement !");
  }

  void addPrelevement(
      BuildContext context,
      PrelevementModel s,
      List passes,
      List images,
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
      "passes": passes,
      "images": images,
      "planSondage": planSondage.toJson(planSondage),
      "securisation": securisation.toJson(securisation)
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: Text("${response.statusCode}"),
          ))
          .closed
          .then((value) async {
        List im = await ImagesQuery().showImages();
        List ps = await PasseQuery().showPasses();
        for (var i in ps) {
          PasseQuery().deletePasse(i[0]);
        }
        for (var i in im) {
          ImagesQuery().deleteImage(i[0]);
        }
      }).whenComplete(() => Navigator.pop(context, true));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
  }

  void updatePrelevement(
      BuildContext context,
      PrelevementModel s,
      List passes,
      List images,
      SecurisationModel securisation,
      PlanSondageModel planSondage) async {
    http.Response response = await _apiServices.post("/Prelevement/update", {
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
      "images": images
    });
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
            content: Text("${response.statusCode}"),
          ))
          .closed
          .then((value) async {
        List im = await ImagesQuery().showImages();
        List ps = await PasseQuery().showPasses();
        for (var i in ps) {
          PasseQuery().deletePasse(i[0]);
        }
        for (var i in im) {
          ImagesQuery().deleteImage(i[0]);
        }
      }).whenComplete(() => Navigator.pop(context, true));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Server error : ${response.statusCode}"),
      ));
    }
  }

  Future<int> nbrBySecurisation(int id, BuildContext context) async {
    http.Response response = await _apiServices.get("/Prelevement/count/$id");
    if (response.statusCode == 200) {
      int count = int.parse(response.body);
      return count;
    } else {
      throw Exception('Failed to retrieve count');
    }
  }
}

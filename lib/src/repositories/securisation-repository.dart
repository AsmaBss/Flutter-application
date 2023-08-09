import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/sqlite/SecurisationQuery.dart';
import 'package:http/http.dart' as http;

class SecurisationRepository {
  final ApiServices _apiServices = ApiServices();

  Future<SecurisationModel?> getByParcelleId(
      int id, BuildContext context) async {
    //try {
    http.Response response =
        await _apiServices.get("/Securisation/show/parcelle/$id");
    if (response.statusCode == 200) {
      if (response.body.isEmpty) {
        return null;
      } else {
        dynamic responseJson = jsonDecode(response.body);
        final securisationData = responseJson;
        return SecurisationModel.fromJson(securisationData);
      }
    } else {
      return await SecurisationQuery().showSecurisationByParcelleId(id);
    }
    /*} on Exception catch (e) {
      throw Exception(e.toString());
    }*/
  }

  Future<void> addSecurisation(
      BuildContext context, SecurisationModel s, ParcelleModel p) async {
    //try {
    http.Response response = await _apiServices.post("/Securisation/add", {
      "securisation": {
        'nom': s.nom,
        'munitionReference': s.munitionReference,
        'cotePlateforme': s.cotePlateforme,
        'profondeurASecuriser': s.profondeurASecuriser,
        'coteASecuriser': s.coteASecuriser,
        'parcelle': s.parcelle,
      },
      "parcelle": p.toJson(p)
    });
    if (response.statusCode == 200) {
      Navigator.pop(context, true);
    } else {
      SecurisationQuery().addSecurisation(s, context);
    }
    /*} catch (e) {
      print('Erreur: $e');
    }*/
  }

  Future<void> updateSecurisation(
      BuildContext context, SecurisationModel s, int id) async {
    //try {
    http.Response response =
        await _apiServices.put("/Securisation/update/$id", s.toJson(s));
    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context, true);
    } else {
      SecurisationQuery().updateSecurisation(s, context);
    }
    /*} catch (e) {
      print('Erreur: $e');
    }*/
  }

  Future<void> deleteSecurisation(
      SecurisationModel s, BuildContext context) async {
    //try {
    http.Response response =
        await _apiServices.delete("/Securisation/delete/${s.id}");
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      await SecurisationQuery().deleteSecurisation(s, context);
    }
    /*} on Exception catch (e) {
      throw Exception(e.toString());
    }*/
  }
}

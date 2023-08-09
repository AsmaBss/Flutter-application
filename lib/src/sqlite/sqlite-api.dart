import 'dart:convert';

import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/ImageModel.dart';
import 'package:flutter_application/src/models/ParcelleModel.dart';
import 'package:flutter_application/src/models/PasseModel.dart';
import 'package:flutter_application/src/models/PlanSondageModel.dart';
import 'package:flutter_application/src/models/PrelevementModel.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/SynchronisationModel.dart';
import 'package:flutter_application/src/models/images-observation-model.dart';
import 'package:flutter_application/src/models/observation-model.dart';
import 'package:flutter_application/src/models/user-model.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:http/http.dart' as http;

class SqliteApi {
  final ApiServices _apiServices = ApiServices();

  void getAllSynchronisation() async {
    List<SynchronisationModel> list =
        await SynchronisationQuery().showAllSynchronisations();
    // Convert the list of objects to JSON
    List<Map<String, dynamic>> jsonData =
        list.map((item) => item.toJson(item)).toList();
    // Prepare the request body
    Map<String, dynamic> requestBody = {
      'synchronisations': jsonData,
    };
    print(requestBody);
    http.Response response = await _apiServices.post(
        "/sqlite/load",
        requestBody
        /*{"synchronisations": list.map((item) => item.toJson(item)).toList();}*/
        ,
        noAuth: true);
    if (response.statusCode == 200) {
      SynchronisationQuery().deleteAllSynchronisations();
    }
  }

  Future<List<UserModel>?> getAllUsers() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/user", noAuth: true);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<UserModel> users =
            data.map((json) => UserModel.fromJson(json)).toList();
        return users;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ParcelleModel>?> getAllParcelles() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/parcelle", noAuth: true);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<ParcelleModel> parcelles =
            data.map((json) => ParcelleModel.fromJson(json)).toList();
        return parcelles;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PlanSondageModel>?> getAllPlansSondage() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/sondage", noAuth: true);
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final data = responseJson as List;
        List<PlanSondageModel> list =
            data.map((json) => PlanSondageModel.fromJson(json)).toList();
        return list;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<SecurisationModel>?> getAllSecurisations() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/securisation", noAuth: true);
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final data = responseJson as List;
        List<SecurisationModel> list =
            data.map((json) => SecurisationModel.fromJson(json)).toList();
        return list;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PrelevementModel>?> getAllPRelevements() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/prelevement", noAuth: true);
      if (response.statusCode == 200) {
        dynamic responseJson = jsonDecode(response.body);
        final data = responseJson as List;
        List<PrelevementModel> list =
            data.map((json) => PrelevementModel.fromJson(json)).toList();
        return list;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<PasseModel>?> getAllPasses() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/passe", noAuth: true);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<PasseModel> passes =
            data.map((json) => PasseModel.fromJson(json)).toList();
        return passes;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ImageModel>?> getAllImagesPrelevement() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/images-prelevement", noAuth: true);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<ImageModel> images =
            data.map((json) => ImageModel.fromJson(json)).toList();
        return images;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ObservationModel>?> getAllObservations() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/observation", noAuth: true);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<ObservationModel> observation =
            data.map((json) => ObservationModel.fromJson(json)).toList();
        return observation;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<ImagesObservationModel>?> getAllImagesObservation() async {
    try {
      http.Response response =
          await _apiServices.get("/sqlite/images-observation", noAuth: true);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final List<ImagesObservationModel> observation =
            data.map((json) => ImagesObservationModel.fromJson(json)).toList();
        return observation;
      } else {
        return [];
      }
    } on Exception catch (e) {
      throw Exception(e.toString());
    }
  }
}

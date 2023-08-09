import 'dart:convert';

import 'package:flutter_application/src/api-services/ApiServices.dart';
import 'package:flutter_application/src/models/SecurisationModel.dart';
import 'package:flutter_application/src/models/SynchronisationModel.dart';
import 'package:flutter_application/src/sqlite/SecurisationQuery.dart';
import 'package:flutter_application/src/sqlite/SynchronisationQuery.dart';
import 'package:http/http.dart' as http;

class SynchronisationRepository {
  final ApiServices _apiServices = ApiServices();

  void getAllSynchronisarion() async {
    //try {
    List<SynchronisationModel> list =
        await SynchronisationQuery().showAllSynchronisations();
    http.Response response = await _apiServices.post(
        "/sqlite/load",
        {
          "synchronisations": list!.map((s) => s.toMap()).toList(),
        },
        /*{
          "synchronisations": list!.map((s) => s.toJson(s)).toList(),
        },*/
        noAuth: true);
    if (response.statusCode == 200) {
      print("sucees");
    }
    /*} on Exception catch (e) {
      throw Exception(e.toString());
    }*/
  }
}

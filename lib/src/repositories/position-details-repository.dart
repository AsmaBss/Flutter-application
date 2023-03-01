import 'dart:convert';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/position-details-model.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:http/http.dart' as http;

class PositionDetailsRepository {
  final ApiServices _apiServices = ApiServices();

  Future<Map<String, dynamic>> getAllPositionDetails() async {
    http.Response response =
        await _apiServices.get("/PositionDetails/show"); // ,params
    dynamic responseJson = jsonDecode(response.body);
    final positionsDetailsData = responseJson as List;
    List<PositionDetailsModel> positionsDetailsList = positionsDetailsData
        .map((json) => PositionDetailsModel.fromJson(json))
        .toList();
    return {
      "positions details list": positionsDetailsList,
    };
  }

  Future<PositionDetailsModel> addPositionDetails(
      PositionDetailsModel pd, PositionModel p) async {
    http.Response response = await _apiServices.post(
        "/PositionDetails/add-position-details/${p.id}", pd.toJson(pd));
    print("statusCode : ${response.statusCode}");
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return PositionDetailsModel.fromJson(jsonData);
  }

  Future<PositionDetailsModel> editPositionDetails(
      PositionDetailsModel p) async {
    http.Response response =
        await _apiServices.put("/PositionDetails/edit-position", p.toJson(p));
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return PositionDetailsModel.fromJson(jsonData);
  }

  void deletePosition(PositionDetailsModel p) async {
    http.Response response =
        await _apiServices.delete("/PositionDetails/delete-position/${p.id}");
    dynamic responseJson = jsonDecode(response.body);
    final jsonMessage = responseJson;
    print(jsonMessage);
  }

  Future<PositionDetailsModel> getPositionDetailsById(
      PositionDetailsModel p) async {
    http.Response response =
        await _apiServices.get("/PositionDetails/show/${p.id}");
    dynamic responseJson = jsonDecode(response.body);
    final positionDetailsData = responseJson;
    return positionDetailsData;
  }
}

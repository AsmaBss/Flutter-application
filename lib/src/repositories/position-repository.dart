import 'dart:convert';
import 'package:flutter_application/src/api-services/api-services.dart';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:http/http.dart' as http;

class PositionRepository {
  final ApiServices _apiServices = ApiServices();

  Future<Map<String, dynamic>> getAllPosition() async {
    // getAllPosition(int page)
    /*
    Map<String, String> params = { 
      "page" : page.toString(),
      "limit" : PAGE_LIMIT.toString()
    }
    */
    http.Response response =
        await _apiServices.get("/Position/show"); // ,params
    dynamic responseJson = jsonDecode(response.body);
    final positionsData = responseJson as List;
    List<PositionModel> positionsList =
        positionsData.map((json) => PositionModel.fromJson(json)).toList();
    return {
      "positions list": positionsList,
    };
  }

  Future<PositionModel> addPosition(PositionModel p) async {
    http.Response response =
        await _apiServices.post("/Position/add-position", p.toJson(p));
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return PositionModel.fromJson(jsonData);
  }

  Future<PositionModel> editPosition(PositionModel p) async {
    http.Response response =
        await _apiServices.put("/Position/edit-position", p.toJson(p));
    dynamic responseJson = jsonDecode(response.body);
    final jsonData = responseJson;
    return PositionModel.fromJson(jsonData);
  }

  void deletePosition(PositionModel p) async {
    http.Response response =
        await _apiServices.delete("/Position/delete-position/${p.id}");
    dynamic responseJson = jsonDecode(response.body);
    final jsonMessage = responseJson;
  }
}

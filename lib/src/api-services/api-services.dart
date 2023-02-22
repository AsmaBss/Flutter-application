import 'dart:convert';
import 'package:flutter_application/src/models/position-model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiServices {
  final String _apiUrl = "${dotenv.env['BASE_URL']}"; // Position/
  Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'accept': 'application/json',
  };

  Future<http.Response> get(String url) async {
    // get(String url, Map<String, String> params)
    try {
      Uri uri = Uri.parse(_apiUrl + url);
      // Uri uri = Uri.parse(_apiUrl + url).replace(queryParameters: params);
      http.Response response = await http.get(uri);
      return response;
    } catch (e) {
      return http.Response({"message ": e}.toString(), 400);
    }
  }

  Future<http.Response> post(String url, Map<String, dynamic> body) async {
    try {
      Uri uri = Uri.parse(_apiUrl + url);
      String bodyString = json.encode(body);
      http.Response response =
          await http.post(uri, headers: _headers, body: bodyString);
      return response;
    } catch (e) {
      return http.Response({"message ": e}.toString(), 400);
    }
  }

  Future<http.Response> put(String url, Map<String, dynamic> body) async {
    try {
      Uri uri = Uri.parse(_apiUrl + url);
      String bodyString = json.encode(body);
      http.Response response =
          await http.put(uri, headers: _headers, body: bodyString);
      return response;
    } catch (e) {
      return http.Response({"message ": e}.toString(), 400);
    }
  }

  Future<http.Response> delete(String url) async {
    try {
      Uri uri = Uri.parse(_apiUrl + url);
      http.Response response = await http.delete(uri, headers: _headers);
      return response;
    } catch (e) {
      return http.Response({"message ": e}.toString(), 400);
    }
  }

/*
  Future<PositionModel> addPosition(PositionModel position) async {
    Map data = {
      'addresse': position.addresse,
      'description': position.description,
      'latitude': position.latitude,
      'longitude': position.longitude
    };

    final Response response = await post(
      Uri.parse(apiUrl + "add-position"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );
    print("response : ${response.body}");
    if (response.statusCode == 200) {
      return PositionModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to post position');
    }
  }
*/
}

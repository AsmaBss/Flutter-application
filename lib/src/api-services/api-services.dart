import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiServices {
  final String _apiUrl = "${dotenv.env['BASE_URL']}";
  Map<String, String> _headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'accept': 'application/json',
  };

  Future<http.Response> get(String url) async {
    try {
      Uri uri = Uri.parse(_apiUrl + url);
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
}

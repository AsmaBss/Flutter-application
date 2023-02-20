import 'dart:convert';

import 'package:flutter_application/src/models/position-model.dart';
import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PositionApiServices {
  final String apiUrl = "${dotenv.env['BASE_URL']}Position/";

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
}

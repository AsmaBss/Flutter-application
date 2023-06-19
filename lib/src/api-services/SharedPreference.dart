import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  // Storing JWT token in local storage
  Future<void> storeJwtToken(String jwtToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwtToken', jwtToken);
  }

  // Retrieving JWT token from local storage
  Future<String?> getJwtToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwtToken');
  }

  // Removing the JWT token
  Future<void> removeJwtToken() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove('jwtToken');
  }
}

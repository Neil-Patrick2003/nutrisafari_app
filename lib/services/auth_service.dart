import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';

class AuthService {
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse("${Config.apiBaseUrl}/parent/login"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: jsonEncode({"email": email, "password": password}),
    );
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data.containsKey("access_token")) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("auth.token", data["access_token"]);
      prefs.setString("auth.user.name", data["user"]['name']);
    } else {
      throw Exception('Something went wrong');
    }
    return data;
  }

  static Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");
    await http.post(
      Uri.parse("${Config.apiBaseUrl}/logout"),
      headers: {"Authorization": "Bearer $token"},
    );
    prefs.remove("token");
  }
}

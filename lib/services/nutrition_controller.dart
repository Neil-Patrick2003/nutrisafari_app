import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/config.dart';

class NutritionService {
  static Future<List<Map<String, dynamic>>> fetchAllPlans() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth.token");

    final response = await http.get(
      Uri.parse("${Config.apiBaseUrl}/parent/nutrition_plans"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Assuming 'data' is a list of maps in the response body
      return List<Map<String, dynamic>>.from(jsonDecode(response.body)['data']);
    } else {
      // Add status code to the exception for better debugging
      throw Exception(
        "Failed to load announcement. Status code: ${response.statusCode}",
      );
    }
  }
}

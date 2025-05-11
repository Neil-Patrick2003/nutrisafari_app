import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:test_app/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnnouncementService {
  static Future<List<Map<String, dynamic>>> fetchAllAnnouncement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth.token");

    final response = await http.get(
      Uri.parse("${Config.apiBaseUrl}/parent/announcements"),
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

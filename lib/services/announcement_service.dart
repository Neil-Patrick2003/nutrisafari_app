import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/config.dart';

class AnnouncementService {
  static Future<Map<String, List<Map<String, dynamic>>>>
  fetchAnnouncementData() async {
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
      final data = jsonDecode(response.body);

      // Defensive check: Ensure the fields exist and are lists
      final announcements =
          data['announcements'] is List
              ? List<Map<String, dynamic>>.from(data['announcements'])
              : <Map<String, dynamic>>[];

      final incomingEvents =
          data['incoming_events'] is List
              ? List<Map<String, dynamic>>.from(data['incoming_events'])
              : <Map<String, dynamic>>[];

      return {
        "announcements": announcements,
        "incoming_events": incomingEvents,
      };
    } else {
      throw Exception(
        "Failed to load data. Status code: ${response.statusCode}",
      );
    }
  }
}

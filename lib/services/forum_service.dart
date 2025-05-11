import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/config.dart';

class ForumService {
  // Fetch all forums
  static Future<List<dynamic>> fetchAllForums() async {
    final response = await http.get(
      Uri.parse("${Config.apiBaseUrl}/parent/forum"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception("Failed to load forums");
    }
  }

  // Create a new forum post
  static Future<String> createForum(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.post(
      Uri.parse("${Config.apiBaseUrl}/parent/forum/create"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"title": title}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["message"];
    } else {
      throw Exception("Failed to create forum");
    }
  }

  // View a specific forum post
  static Future<Map<String, dynamic>> viewForum(int forumId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.get(
      Uri.parse("${Config.apiBaseUrl}/parent/forum/$forumId"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception("Failed to load forum details");
    }
  }

  // Reply to a forum post
  static Future<String> reply(int forumId, String body) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.post(
      Uri.parse("${Config.apiBaseUrl}/parent/forum/$forumId/reply"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"body": body}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception("Failed to post a reply");
    }
  }
}

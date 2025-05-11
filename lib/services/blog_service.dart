import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/config.dart';

class BlogService {
  static Future<List<dynamic>> fetchAllForums() async {
    final response = await http.get(
      Uri.parse("${Config.apiBaseUrl}/parent/blogs"),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    } else {
      throw Exception("Failed to load blogs");
    }
  }

  static Future<String> createForum(
    String title,
    String body,
    String imageUrl,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    final response = await http.post(
      Uri.parse("${Config.apiBaseUrl}/parent/blogs/create"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"title": title, "body": body, "imageUrl": imageUrl}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body)["message"];
    } else {
      throw Exception("Failed to create blogs");
    }
  }
}

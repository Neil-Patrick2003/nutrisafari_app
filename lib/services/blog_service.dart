import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/config.dart';

class BlogService {
  static Future<List<Map<String, dynamic>>> fetchBlogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth.token");

    final response = await http.get(
      Uri.parse("${Config.apiBaseUrl}/parent/blog"),
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

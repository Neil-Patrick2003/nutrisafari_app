import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/config.dart';

class ForumService {
  // Fetch all forums
  static Future<List<Map<String, dynamic>>> fetchAllForums() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth.token");

    final response = await http.get(
      Uri.parse("${Config.apiBaseUrl}/parent/forum"),
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

  // Create a new forum post
  static Future<String> createForum(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth.token");

    // Check if the token is null and handle accordingly
    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    try {
      final response = await http.post(
        Uri.parse("${Config.apiBaseUrl}/parent/forum"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"title": title}),
      );

      // Log the raw response body for debugging
      print("Response Body: ${response.body}");

      // Check for successful response
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Ensure the response body is not null
        var decodedResponse = jsonDecode(response.body);
        print("Decoded Response: $decodedResponse"); // Debugging log

        if (decodedResponse != null && decodedResponse.containsKey("message")) {
          return decodedResponse["message"];
        } else {
          throw Exception("Unexpected response format.");
        }
      } else {
        // Handle non-200 response codes
        throw Exception("Failed to create forum: ${response.statusCode}");
      }
    } catch (e) {
      // Handle errors like network failure or json decoding errors
      throw Exception("Error creating forum: $e");
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
}

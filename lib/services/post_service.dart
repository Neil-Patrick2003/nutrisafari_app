import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/config.dart';

class PostService {
  static Future<String> createForum(String title, int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth.token");

    // Check if the token is null and handle accordingly
    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    try {
      final response = await http.post(
        Uri.parse("${Config.apiBaseUrl}/parent/forum/$id/post"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"body": title}),
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
}

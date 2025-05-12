import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/config.dart';
import 'dart:io';

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

  // Create a new forum post
  static Future<String> createBlog(
    String title,
    String bodyText,
    File imageFile,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth.token");

    if (token == null) {
      throw Exception("Authentication token is missing.");
    }

    try {
      var uri = Uri.parse("${Config.apiBaseUrl}/parent/blog");
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = "Bearer $token";
      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Accept'] = 'application/json';

      request.fields['title'] = title;
      request.fields['body'] = bodyText;

      // Add the image file
      request.files.add(
        await http.MultipartFile.fromPath('image', imageFile.path),
      );

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        var decodedResponse = jsonDecode(response.body);
        print("Decoded Response: $decodedResponse");

        if (decodedResponse != null && decodedResponse.containsKey("message")) {
          return decodedResponse["message"];
        } else {
          throw Exception("Unexpected response format.");
        }
      } else {
        throw Exception("Failed to create forum: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error creating forum: $e");
    }
  }
}

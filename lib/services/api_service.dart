import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletools/main.dart';

class ApiService {
  static const String _devBaseUrl = "https://tabletools.ngrok.dev/api";
  static const String _prodBaseUrl = "https://tabletools.io/api";
  static String get baseUrl => isProduction ? _prodBaseUrl : _devBaseUrl;

  static void printEnv() {
    print("🌎 API Base URL: $baseUrl (Production: $isProduction)");
  }
  /// Fetch generator data with JWT authentication
  static Future<String> fetchGeneratorData(String generatorType) async {
    final url = "$baseUrl/generator/generate_$generatorType";
    print("📡 API Request: POST $url");

    try {
      // 🔹 Retrieve JWT token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null || token.isEmpty) {
        print("⚠️ No Auth Token Found! Unauthorized request.");
        throw Exception("Unauthorized: No JWT token found.");
      }

      // 🔹 Make API request with Authorization header
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ Attach JWT token
        },
      );

      if (response.statusCode == 200) {
        print("✅ API Success: ${response.body}");
        return response.body;
      } else {
        print("⚠️ API Error: ${response.statusCode} ${response.body}");
        throw Exception("Failed to load data: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API Exception: $e");
      throw Exception("API request failed: $e");
    }
  }

  /// Send modified data with JWT authentication
  static Future<String> sendModifiedData(String generatorType, Map<String, dynamic> data) async {
    final url = "$baseUrl/generator/generate_$generatorType";
    print("📡 API Request: POST $url with data: ${json.encode(data)}");

    try {
      // 🔹 Retrieve JWT token
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null || token.isEmpty) {
        print("⚠️ No Auth Token Found! Unauthorized request.");
        throw Exception("Unauthorized: No JWT token found.");
      }

      // 🔹 Make API request with Authorization header
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // ✅ Attach JWT token
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        print("✅ API Success: ${response.body}");
        return response.body;
      } else {
        print("⚠️ API Error: ${response.statusCode} ${response.body}");
        throw Exception("Failed to update data: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API Exception: $e");
      throw Exception("API request failed: $e");
    }
  }

  static Future<Map<String, dynamic>> registerUser(
      String email, String name, String password) async {
    final url = "$baseUrl/create-account";
    print("📡 API Request: POST $url");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "name": name, "password": password}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final authToken = response.headers['authorization'] ?? "";

        // if (authToken.isNotEmpty) {
        //   SharedPreferences prefs = await SharedPreferences.getInstance();
        //   await prefs.setString('authToken', authToken);
        //   print("💾 Auth Token Stored in SharedPreferences");
        // }

        return {
          "success": true,
          "authToken": authToken,
          "message": responseBody["success"] ?? "Account created successfully",
        };
      } else {
        print(
            "⚠️ Registration Failed: ${response.statusCode} ${response.body}");
        return {
          "success": false,
          "message":
              json.decode(response.body)["error"] ?? "Registration failed",
        };
      }
    } catch (e) {
      print("❌ API Exception: $e");
      return {"success": false, "message": "Registration request failed: $e"};
    }
  }

  /// ✅ Login an existing user
  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    final url = "$baseUrl/login";
    print("📡 API Request: POST $url");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final authToken = response.headers['authorization'] ?? "";

        print("✅ Login Success: ${response.body}");
        print("🔑 Auth Token: $authToken");

        if (authToken.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', authToken); // Store the token

          print("💾 Auth Token Stored in SharedPreferences");
        } else {
          print("⚠️ No Auth Token Received");
        }

        return {
          "success": true,
          "authToken": authToken,
          "message": responseBody["message"] ?? "Login successful",
        };
      } else {
        print("⚠️ Login Failed: ${response.statusCode} ${response.body}");
        return {
          "success": false,
          "message": json.decode(response.body)["error"] ?? "Login failed",
        };
      }
    } catch (e) {
      print("❌ API Exception: $e");
      return {"success": false, "message": "Login request failed: $e"};
    }
  }

  static Future<Map<String, String>> verifyAccount(String token) async {
    final url = "$baseUrl/verify-account";
    print("📡 API Request: POST $url with token: $token");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"key": token}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final authToken =
            response.headers['authorization'] ?? ""; // Ensure it's a string

        print("✅ API Success: ${response.body}");
        print("🔑 Auth Token: $authToken");

        if (authToken.isNotEmpty) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('authToken', authToken); // Store the token

          print("💾 Auth Token Stored in SharedPreferences");
        } else {
          print("⚠️ No Auth Token Received");
        }

        return {
          "message": responseBody["success"] ?? "Verification successful",
          "authToken": authToken, // Always return a string
        };
      } else {
        print("⚠️ API Error: ${response.statusCode} ${response.body}");
        throw Exception("Failed to verify account: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API Exception: $e");
      throw Exception("API request failed: $e");
    }
  }
}

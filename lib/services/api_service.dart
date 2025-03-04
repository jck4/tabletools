import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tabletools/main.dart';
import 'package:tabletools/utils/storage_helper.dart';

class ApiService {
  static const String _devBaseUrl = "https://tabletools.ngrok.dev/api";
  static const String _prodBaseUrl = "https://www.tabletools.io/api";
  static String get baseUrl => isProduction ? _prodBaseUrl : _devBaseUrl;

  static void printEnv() {
    print("🌎 API Base URL: $baseUrl (Production: $isProduction)");
  }

  /// 🔹 Retrieve JWT Token using StorageHelper
  static Future<String?> _getAuthToken() async {
    return await StorageHelper.getToken();
  }

  /// ✅ Fetch generator data with JWT authentication
  static Future<String> fetchGeneratorData(String generatorType) async {
    final url = "$baseUrl/generator/generate_$generatorType";
    print("📡 API Request: POST $url");

    try {
      String? token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No Auth Token Found! Unauthorized request.");
        throw Exception("Unauthorized: No JWT token found.");
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
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

  /// ✅ Send modified data with JWT authentication
  static Future<String> sendModifiedData(
      String generatorType, Map<String, dynamic> data) async {
    final url = "$baseUrl/generator/generate_$generatorType";
    print("📡 API Request: POST $url with data: ${json.encode(data)}");

    try {
      String? token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        print("⚠️ No Auth Token Found! Unauthorized request.");
        throw Exception("Unauthorized: No JWT token found.");
      }

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
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

  /// ✅ Register a new user
  static Future<Map<String, dynamic>> registerUser(
      String email, String name, String password) async {
    final url = "$baseUrl/auth/create-account";
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

        if (authToken.isNotEmpty) {
          await StorageHelper.saveToken(authToken);
          print("💾 Auth Token Stored in StorageHelper");
        }

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
    final url = "$baseUrl/auth/login";
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
          await StorageHelper.saveToken(authToken);
          print("💾 Auth Token Stored in StorageHelper");
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

  /// ✅ Verify Account
  static Future<Map<String, String>> verifyAccount(String token) async {
    final url = "$baseUrl/auth/verify-account";
    print("📡 API Request: POST $url with token: $token");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"key": token}),
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final authToken = response.headers['authorization'] ?? "";

        print("✅ API Success: ${response.body}");
        print("🔑 Auth Token: $authToken");

        if (authToken.isNotEmpty) {
          await StorageHelper.saveToken(authToken);
          print("💾 Auth Token Stored in StorageHelper");
        } else {
          print("⚠️ No Auth Token Received");
        }

        return {
          "message": responseBody["success"] ?? "Verification successful",
          "authToken": authToken,
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

  /// ✅ Fetch authenticated user's profile

static Future<Map<String, dynamic>> fetchCompendium() async {
  final url = "$baseUrl/compendium";
  print("📡 API Request: GET $url");

  try {
    String? token = await _getAuthToken();
    if (token == null || token.isEmpty) {
      print("⚠️ No Auth Token Found! Unauthorized request.");
      throw Exception("Unauthorized: No JWT token found.");
    }

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print("✅ API Success: ${response.body}");
      
      return responseBody; // ✅ Return raw JSON, let UI format it
    } else {
      print("⚠️ API Error: ${response.statusCode} ${response.body}");
      throw Exception("Failed to fetch compendium: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ API Exception: $e");
    throw Exception("API request failed: $e");
  }
}

static Future<Map<String, dynamic>> saveToCompendium(
    String category, Map<String, dynamic> entry) async {
  final url = "$baseUrl/compendium/save";
  print("📡 API Request: POST $url");

  try {
    String? token = await _getAuthToken();
    if (token == null || token.isEmpty)
      throw Exception("Unauthorized: No JWT token found.");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({"category": category, "entry": entry}),
    );

    final responseBody = json.decode(response.body);
    
    if (response.statusCode == 200 || response.statusCode == 409) {
      print("✅ API Response: ${response.body}");
      return responseBody; // ✅ Return the response to the UI
    } else {
      throw Exception(responseBody["message"] ?? "Failed to save entry.");
    }
  } catch (e) {
    print("❌ API Exception: $e");
    throw Exception("API request failed: $e");
  }
}

static Future<Map<String, dynamic>> deleteFromCompendium(
    String category, String entryId) async {
  final url = "$baseUrl/compendium";
  print("📡 API Request: DELETE $url");

  try {
    String? token = await _getAuthToken();
    if (token == null || token.isEmpty)
      throw Exception("Unauthorized: No JWT token found.");

    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({"category": category, "entry_id": entryId}),
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200 || response.statusCode == 404) {
      print("✅ API Response: ${response.body}");
      return responseBody; // ✅ Return API message
    } else {
      throw Exception(responseBody["message"] ?? "Failed to delete entry.");
    }
  } catch (e) {
    print("❌ API Exception: $e");
    throw Exception("API request failed: $e");
  }
}

  /// ✅ Fetch user profile with caching
  static Future<Map<String, dynamic>> fetchProfile({bool forceRefresh = false}) async {
    final url = "$baseUrl/profile";
    print("📡 API Request: GET $url");

    try {
      // 🔹 Try fetching cached profile first, unless forceRefresh is true
      if (!forceRefresh) {
        String? cachedProfile = await StorageHelper.getProfile();
        if (cachedProfile != null) {
          print("✅ Loaded cached profile");
          return json.decode(cachedProfile);
        }
      }

      // 🔹 Fetch from API if no cache or forceRefresh is true
      String? token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: No JWT token found.");
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print("✅ API Success: ${response.body}");

        // ✅ Cache profile data
        await StorageHelper.saveProfile(json.encode(responseBody));

        return responseBody;
      } else {
        throw Exception("Failed to fetch profile: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API Exception: $e");
      throw Exception("API request failed: $e");
    }
  }

  /// ✅ Update user profile and cache new data
  static Future<void> updateProfile(Map<String, dynamic> updatedData) async {
    final url = "$baseUrl/profile/update";
    print("📡 API Request: PATCH $url");

    try {
      String? token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized: No JWT token found.");
      }

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: json.encode(updatedData),
      );

      if (response.statusCode == 200) {
        print("✅ Profile updated successfully");

        // ✅ Refresh cached profile after update
        await fetchProfile(forceRefresh: true);
      } else {
        throw Exception("Failed to update profile: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ API Exception: $e");
      throw Exception("API request failed: $e");
    }
  }

}

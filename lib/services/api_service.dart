import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://tabletools-backend-61e6b812502f.herokuapp.com";

  static Future<String> fetchGeneratorData(String generatorType) async {
    final url = "$baseUrl/generator/generate_$generatorType";
    print("📡 API Request: GET $url");

    try {
      final response = await http.post(Uri.parse(url));

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

  static Future<String> sendModifiedData(String generatorType, Map<String, dynamic> data) async {
    final url = "$baseUrl/generator/generate_$generatorType";
    print("📡 API Request: POST $url with data: ${json.encode(data)}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
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
}

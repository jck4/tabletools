import 'dart:convert';
import 'api_service.dart';
import 'package:flutter/foundation.dart';

class GeneratorService {
  static Future<Map<String, dynamic>?> fetchGeneratorData(String type) async {
    return _handleApiCall(() => ApiService.fetchGeneratorData(type));
  }

  static Future<Map<String, dynamic>?> sendModifiedData(String type, Map<String, dynamic> modifiedData) async {
    return _handleApiCall(() => ApiService.sendModifiedData(type, modifiedData));
  }

  static Future<Map<String, dynamic>?> _handleApiCall(Future<String> Function() apiCall) async {
    try {
      String jsonString = await apiCall();
      return json.decode(jsonString);
    } catch (e) {
      if (kDebugMode) {
      }
      return null;
    }
  }
}

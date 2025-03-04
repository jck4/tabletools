import 'dart:io' show Platform;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/html.dart' as html;
import 'package:flutter/foundation.dart'; // ✅ Import for kIsWeb

class StorageHelper {
  static final _secureStorage = const FlutterSecureStorage();

  /// ✅ Save Auth Token
  static Future<void> saveToken(String token) async {
    if (kIsWeb) {
      html.window.localStorage['authToken'] = token; // Web Storage
    } else if (Platform.isAndroid || Platform.isIOS) {
      await _secureStorage.write(key: 'authToken', value: token);
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('authToken', token);
    }
  }

  /// ✅ Get Auth Token
  static Future<String?> getToken() async {
    if (kIsWeb) {
      return html.window.localStorage['authToken']; // Web Storage
    } else if (Platform.isAndroid || Platform.isIOS) {
      return await _secureStorage.read(key: 'authToken');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('authToken');
    }
  }

  /// ✅ Save Profile Data
  static Future<void> saveProfile(String profileData) async {
    if (kIsWeb) {
      html.window.localStorage['profile'] = profileData; // Web Storage
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile', profileData);
    }
  }

  /// ✅ Get Profile Data
  static Future<String?> getProfile() async {
    if (kIsWeb) {
      return html.window.localStorage['profile']; // Web Storage
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getString('profile');
    }
  }

  /// ✅ Remove Auth Token & Profile
  static Future<void> removeToken() async {
    if (kIsWeb) {
      html.window.localStorage.remove('authToken');
      html.window.localStorage.remove('profile'); // Clear profile
    } else if (Platform.isAndroid || Platform.isIOS) {
      await _secureStorage.delete(key: 'authToken');
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
      await prefs.remove('profile'); // Clear profile
    }
  }
}

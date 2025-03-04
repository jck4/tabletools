import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_links/uni_links.dart'; // ✅ Import for deep links
import '../services/api_service.dart'; // ✅ Import API calls

class AuthProvider extends ChangeNotifier {
  bool _isLoggedIn = false;

  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _loadLoginState();
    _initDeepLinkListener(); // ✅ Start listening for deep links
  }

  Future<void> _loadLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    if (token != null) {
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
      prefs.remove('authToken'); // ✅ Remove token if missing
    }

    notifyListeners();
    startTokenCheck();
  }

  Future<void> login(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('authToken', token);
    _isLoggedIn = true;
    notifyListeners();
    startTokenCheck();
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken');
    _isLoggedIn = false;
    notifyListeners();
  }

  void startTokenCheck() {
    Timer.periodic(Duration(minutes: 5), (timer) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) {
        print("⚠️ No token found! Logging out...");
        logout();
        timer.cancel();
      }
    });
  }

  /// ✅ **Deep Link Handling**
  void _initDeepLinkListener() async {
    try {
      // Handle initial deep link
      String? initialLink = await getInitialLink();
      if (initialLink != null) {
        _handleDeepLink(initialLink);
      }

      // Listen for deep link changes
      linkStream.listen((String? link) {
        if (link != null) {
          _handleDeepLink(link);
        }
      });
    } catch (e) {
      print("❌ Error handling deep link: $e");
    }
  }

  /// ✅ **Process Deep Links (e.g., Verify Account)**
  void _handleDeepLink(String link) async {
    Uri uri = Uri.parse(link);
    print("🔗 Deep link received: $link");

    if (uri.path == '/verify') {
      String? token = uri.queryParameters['key'];
      print("🔑 Token extracted: $token");

      if (token != null) {
        try {
          Map<String, String> response = await ApiService.verifyAccount(token);

          if (response.containsKey("authToken") && response["authToken"]!.isNotEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('authToken', response["authToken"]!);

            print("✅ Deep Link Login Success! Auth Token Stored.");

            notifyListeners(); // ✅ Notify UI that user is logged in
          } else {
            print("⚠️ Verification failed or no auth token received.");
          }
        } catch (e) {
          print("❌ Error verifying deep link: $e");
        }
      }
    }
  }
}

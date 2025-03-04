import 'package:flutter/material.dart';
import 'package:tabletools/services/api_service.dart'; // Ensure this points to your `ApiService`
import 'package:tabletools/utils/storage_helper.dart'; // ✅ Import storage helper
import 'dart:async';
import 'dart:convert';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  String _userName = "Adventurer"; // Default fallback name
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

Future<void> _loadProfile() async {
  try {
    // 🔹 Call API Service, which handles caching internally
    final profile = await ApiService.fetchProfile();
    
    setState(() {
      _userName = profile['name'] ?? "Adventurer";
      _isLoading = false;
    });

    print("✅ Profile loaded: $_userName");
  } catch (e) {
    print("❌ Failed to fetch profile: $e");
    setState(() {
      _isLoading = false;
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg', // Ensure this image is in your assets folder
              fit: BoxFit.cover,
            ),
          ),
          // Foreground Content
          SafeArea(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'TableTools',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    _isLoading
                        ? CircularProgressIndicator() // Show loader while fetching
                        : Text(
                            'Welcome, $_userName!',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                    SizedBox(height: 10),
                    Text(
                      'Enhance your tabletop RPG sessions! Create custom encounters, craft unique traps, and explore exciting tools. Dive into our compendium for a vast collection of creatures, items, and spells.',
                      style: TextStyle(fontSize: 18, color: Colors.black87),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

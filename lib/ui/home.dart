import 'package:flutter/material.dart';
import 'package:tabletools/services/api_service.dart'; // Ensure this points to your `ApiService`
import 'package:tabletools/utils/storage_helper.dart'; // ✅ Import storage helper
import 'package:tabletools/utils/app_theme.dart';
import 'dart:async';
import 'dart:convert';
import 'generator/generator_screen.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  HomeWidgetState createState() => HomeWidgetState();
}

class HomeWidgetState extends State<HomeWidget> {
  String _userName = "Adventurer"; // Default fallback name
  bool _isLoading = true;
  List<Map<String, dynamic>> _featuredItems = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadFeaturedItems();
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

  Future<void> _loadFeaturedItems() async {
    // Simulated featured items that would normally come from an API
    setState(() {
      _featuredItems = [
        {
          'title': 'NPC Generator',
          'description': 'Create rich characters for your campaign',
          'icon': AppTheme.categoryIcons['npc'],
          'color': AppTheme.categoryColors['npc'],
          'action': 'Generate NPCs',
          'destination': 'npc_generator'
        },
        {
          'title': 'Encounter Builder',
          'description': 'Design balanced combat encounters for your party',
          'icon': AppTheme.categoryIcons['encounter'],
          'color': AppTheme.categoryColors['encounter'],
          'action': 'Build Encounters',
          'destination': 'encounter_generator'
        },
        {
          'title': 'Compendium',
          'description': 'Browse your collection of custom content',
          'icon': Icons.menu_book,
          'color': AppTheme.primary,
          'action': 'View Compendium',
          'destination': 'compendium'
        },
      ];
    });
  }

  void _navigateToDestination(String destination) {
    switch (destination) {
      case 'npc_generator':
        // Navigate to NPC generator
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeneratorScreen(generatorType: 'npc'),
          ),
        );
        break;
      case 'encounter_generator':
        // Navigate to encounter generator
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GeneratorScreen(generatorType: 'encounter'),
          ),
        );
        break;
      case 'compendium':
        // For compendium, just show a message since we can't directly switch tabs
        // In a real app, you'd implement a state management solution to handle this
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Use the bottom navigation bar to view the Compendium'),
            duration: Duration(seconds: 2),
            backgroundColor: AppTheme.primary,
          ),
        );
        break;
      default:
        // Default action if destination not recognized
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parchment.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.lighten,
            ),
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16),
                padding: EdgeInsets.all(16),
                decoration: AppTheme.headerDecoration,
                child: Column(
                  children: [
                    // Logo and title
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.accentLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.auto_stories,
                            color: AppTheme.primaryDark,
                            size: 30,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'TableTools',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textOnPrimary,
                                letterSpacing: 1.2,
                              ),
                            ),
                            Text(
                              'RPG Companion',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppTheme.textOnPrimary.withOpacity(0.8),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    // Welcome message
                    _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.accentLight),
                            ),
                          )
                        : Row(
                            children: [
                              Icon(
                                Icons.emoji_events,
                                color: AppTheme.accent,
                                size: 24,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Welcome back, $_userName!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textOnPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              
              // App description
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.background.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: Text(
                  'Enhance your tabletop RPG sessions with powerful tools for Game Masters. Create custom encounters, craft unique NPCs, design traps, and build a personal compendium of content.',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppTheme.textPrimary,
                    height: 1.5,
                  ),
                ),
              ),
              
              // Section title
              Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Row(
                  children: [
                    Icon(Icons.star, color: AppTheme.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'FEATURED TOOLS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Featured items
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _featuredItems.length,
                  itemBuilder: (context, index) {
                    final item = _featuredItems[index];
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => _navigateToDestination(item['destination']),
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon
                              Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: item['color'],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  item['icon'],
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              SizedBox(width: 16),
                              // Content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'],
                                      style: AppTheme.titleStyle,
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      item['description'],
                                      style: AppTheme.subtitleStyle,
                                    ),
                                    SizedBox(height: 12),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: OutlinedButton.icon(
                                        onPressed: () => _navigateToDestination(item['destination']),
                                        icon: Icon(Icons.arrow_forward, size: 16),
                                        label: Text(item['action']),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: item['color'],
                                          side: BorderSide(color: item['color']),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Footer with version
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                color: AppTheme.primaryDark.withOpacity(0.9),
                child: Text(
                  '© TableTools v1.0',
                  style: TextStyle(
                    color: AppTheme.textOnPrimary,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

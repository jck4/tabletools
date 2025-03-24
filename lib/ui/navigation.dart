import 'package:flutter/material.dart';
import 'home.dart';
import 'compendium.dart';
import 'generator/generator_selection.dart';
import 'package:provider/provider.dart'; 
import 'package:tabletools/services/auth_service.dart'; 
import 'package:tabletools/ui/screens/profile_screen.dart';
import 'package:tabletools/utils/app_theme.dart';

class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  static final List<Widget> _pages = [
    HomeWidget(),
    CompendiumScreen(),
    GeneratorWidget(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _logout() async {
    Provider.of<AuthProvider>(context, listen: false).logout(); 
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()), // ✅ Show loading screen
      );
    }

    // Define titles for each tab
    final List<String> _pageTitles = [
      "TableTools",
      "Compendium",
      "Generator", 
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _pageTitles[_selectedIndex],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _selectedIndex == 1 ? AppTheme.textOnPrimary : null, // Special styling for Compendium
          ),
        ),
        backgroundColor: _selectedIndex == 1 ? AppTheme.primaryDark : null, // Special styling for Compendium
        elevation: _selectedIndex == 1 ? 4 : null, // Add elevation for Compendium
        iconTheme: IconThemeData(
          color: _selectedIndex == 1 ? AppTheme.textOnPrimary : null, // Set icon color for Compendium
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Compendium',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_fix_high),
            label: 'Generator',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'home.dart';
import 'compendium.dart';
import 'generator_widget.dart';
import 'package:provider/provider.dart'; // ✅ Import Provider
import '../services/auth_provider.dart'; // ✅ Import AuthProvider
class MainLayout extends StatefulWidget {
  @override
  _MainLayoutState createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;
  bool _isLoading = false;
  static final List<Widget> _pages = [
    HomeWidget(),
    CompendiumWidget(),
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

    return Scaffold(
      appBar: AppBar(
        title: Text("TableTools"),
        actions: [
            IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // ✅ Calls the logout function
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
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
        onTap: _onItemTapped,
      ),
    );
  }
}


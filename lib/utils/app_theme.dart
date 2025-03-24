import 'package:flutter/material.dart';

/// App-wide theme definitions for TableTools
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // Primary palette
  static final Color primaryDark = Colors.brown[800]!;
  static final Color primary = Colors.brown[700]!;
  static final Color primaryLight = Colors.brown[600]!;
  
  // Accent colors
  static final Color accentLight = Colors.amber[100]!;
  static final Color accent = Colors.amber[300]!;
  static final Color accentDark = Colors.amber[700]!;

  // Background colors
  static final Color background = Colors.brown[50]!;
  static final Color cardBackground = Colors.white;
  static final Color divider = Colors.brown[200]!;

  // Text colors
  static final Color textOnPrimary = Colors.amber[100]!;
  static final Color textPrimary = Colors.brown[900]!;
  static final Color textSecondary = Colors.brown[700]!;
  static final Color textHint = Colors.brown[400]!;

  // Category specific colors
  static final Map<String, Color> categoryColors = {
    'npc': Colors.blue[700]!,
    'encounter': Colors.green[700]!,
    'trap': Colors.red[700]!,
    'treasure': Colors.amber[700]!,
    'quest': Colors.purple[700]!,
    'default': Colors.brown[700]!,
  };

  // Category specific icons
  static final Map<String, IconData> categoryIcons = {
    'npc': Icons.person,
    'encounter': Icons.terrain,
    'trap': Icons.dangerous,
    'treasure': Icons.enhanced_encryption,
    'quest': Icons.catching_pokemon,
    'default': Icons.article,
  };

  // Common text styles
  static final TextStyle headerStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textOnPrimary,
    letterSpacing: 1.2,
  );

  static final TextStyle titleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static final TextStyle subtitleStyle = TextStyle(
    fontSize: 14,
    color: textSecondary,
  );

  // Common decorations
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardBackground.withOpacity(0.95),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(color: divider),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  static BoxDecoration headerDecoration = BoxDecoration(
    color: primaryDark,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.3),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  // Helper method to get color for a category
  static Color getColorForCategory(String category) {
    return categoryColors[category.toLowerCase()] ?? categoryColors['default']!;
  }

  // Helper method to get icon for a category
  static IconData getIconForCategory(String category) {
    return categoryIcons[category.toLowerCase()] ?? categoryIcons['default']!;
  }

  // Default app theme
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: primary,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryDark,
        foregroundColor: textOnPrimary,
        elevation: 4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textOnPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: BorderSide(color: primary),
        ),
      ),
    );
  }
} 
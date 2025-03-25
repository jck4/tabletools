import 'package:flutter/material.dart';
import 'ui/quick_generators/quick_generator_screen.dart';
import 'utils/app_theme.dart';

void main() {
  runApp(Tabletools());
}

class Tabletools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TableTools',
      theme: AppTheme.getTheme(),
      home: QuickGeneratorScreen(),
    );
  }
}



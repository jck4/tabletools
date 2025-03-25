import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import 'quick_generator_screen.dart';

/// A floating action button that provides quick access to generators
class QuickGeneratorFAB extends StatelessWidget {
  const QuickGeneratorFAB({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => QuickGeneratorScreen(),
          ),
        );
      },
      backgroundColor: AppTheme.accentDark,
      child: Icon(Icons.flash_on, color: Colors.white),
      tooltip: 'Quick Generators',
    );
  }
} 
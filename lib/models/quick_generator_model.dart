import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

/// Model to define quick generator types
class QuickGeneratorType {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String Function() generate;
  
  QuickGeneratorType({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    required this.generate,
  });
} 
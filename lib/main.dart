import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/premium_manager.dart';
import 'ui/navigation.dart'; // Import MainLayout or GeneratorWidget

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PremiumManager()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TableTools',
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: MainLayout(), // Ensure this is where navigation starts
    );
  }
}

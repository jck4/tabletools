import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/auth_provider.dart';
import 'ui/navigation.dart';
import 'ui/login_screen.dart';

const bool isProduction = bool.fromEnvironment('IS_PRODUCTION', defaultValue: false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isProduction) {
    HttpOverrides.global = MyHttpOverrides();
    print("⚠️ SSL Verification is DISABLED (Development Mode)");
  } else {
    print("✅ SSL Verification is ENABLED (Production Mode)");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), 
      ],
      child: MyApp(),
    ),
  );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print("🔄 Auth State Updated: isLoggedIn = ${authProvider.isLoggedIn}");
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TableTools',
          theme: ThemeData(primarySwatch: Colors.indigo),
          home: authProvider.isLoggedIn ? MainLayout() : LoginScreen(), // ✅ Redirect based on token state
        );
      },
    );
  }
}



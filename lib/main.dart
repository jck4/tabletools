import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';
import 'ui/navigation.dart';
import 'ui/screens/login_screen.dart';
import 'utils/app_theme.dart';

const bool isProduction = bool.fromEnvironment('IS_PRODUCTION', defaultValue: true);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!isProduction) {
    HttpOverrides.global = DevHttpOverrides();
    print("⚠️ SSL Verification is DISABLED (Development Mode)");
  } else {
    print("✅ SSL Verification is ENABLED (Production Mode)");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()), 
      ],
      child: Tabletools(),
    ),
  );
}

class DevHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class Tabletools extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print("🔄 Auth State Updated: isLoggedIn = ${authProvider.isLoggedIn}");
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'TableTools',
          theme: AppTheme.getTheme(),
          home: authProvider.isLoggedIn ? MainLayout() : LoginScreen(), // ✅ Redirect based on token state
        );
      },
    );
  }
}



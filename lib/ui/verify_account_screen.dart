import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Import ApiService

class VerifyAccountScreen extends StatefulWidget {
  final String? token;

  VerifyAccountScreen({this.token});

  @override
  _VerifyAccountScreenState createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  String _statusMessage = "Verifying...";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _verifyAccount();
  }

  void _verifyAccount() async {
    if (widget.token == null) {
      setState(() {
        _statusMessage = "Invalid token.";
        _isLoading = false;
      });
      return;
    }

    try {
      final result = await ApiService.verifyAccount(widget.token!);
      String successMessage = result["message"]!;
      String authToken = result["authToken"]!;

      setState(() {
        _statusMessage = successMessage;
        _isLoading = false;
      });

      print("✅ Success: $successMessage");
      print("🔑 Auth Token: $authToken");

      // Optionally, store authToken for future authenticated requests

      // Automatically navigate back after 2 seconds
      Future.delayed(Duration(seconds: 2), () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      });
    } catch (e) {
      setState(() {
        _statusMessage = "Verification failed: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Account Verification')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator() // Show loading indicator while verifying
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_statusMessage),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: Text('Back to Home'),
                  ),
                ],
              ),
      ),
    );
  }
}

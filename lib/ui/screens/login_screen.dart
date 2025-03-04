import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tabletools/services/api_service.dart';
import 'package:tabletools/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isRegisterMode = false;
  bool _isLoading = false;
  String _errorMessage = "";
  String _successMessage = "";

  @override
  void initState() {
    super.initState();
    _loadRegisterMode();
  }

  Future<void> _loadRegisterMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isRegisterMode = prefs.getBool('isRegisterMode') ?? false;
    });
  }

  Future<void> _saveRegisterMode(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isRegisterMode', value);
  }

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = "";
      _successMessage = "";
    });

    Map<String, dynamic> response;
    if (_isRegisterMode) {
      response = await ApiService.registerUser(
        _emailController.text,
        _nameController.text,
        _passwordController.text,
      );
    } else {
      response = await ApiService.loginUser(
        _emailController.text,
        _passwordController.text,
      );
    }

    setState(() {
      _isLoading = false;
    });

    if (response["success"] == true) {
      final authToken = response["authToken"];
      setState(() {
        _successMessage = response["message"] ?? "Success!";
      });

      if (!_isRegisterMode && authToken != null) {
        Provider.of<AuthProvider>(context, listen: false).login(authToken);
      }
    } else {
      // ✅ Show specific message for unverified accounts
      if (response["message"]?.contains("not verified") == true) {
        setState(() {
          _errorMessage = "Your account has not been verified. Please check your email.";
        });
      } else {
        setState(() {
          _errorMessage = response["message"] ?? "Something went wrong";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/bg.jpg', // Ensure this image exists in assets
              fit: BoxFit.cover,
            ),
          ),

          // Foreground Content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'TableTools',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      Text(
                        _isRegisterMode ? "Create an account" : "Sign in to continue",
                        style: TextStyle(fontSize: 18, color: Colors.black87),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (_isRegisterMode)
                              Column(
                                children: [
                                  _buildTextField(_nameController, "Name"),
                                  SizedBox(height: 10),
                                ],
                              ),
                            _buildTextField(_emailController, "Email", isEmail: true),
                            SizedBox(height: 10),
                            _buildTextField(_passwordController, "Password", isPassword: true),
                            SizedBox(height: 10),
                            if (_errorMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  _errorMessage,
                                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (_successMessage.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  _successMessage,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            SizedBox(height: 10),
                            _isLoading
                                ? CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: _authenticate,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.indigo[800],
                                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      _isRegisterMode ? "Register" : "Login",
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isRegisterMode = !_isRegisterMode;
                                  _saveRegisterMode(_isRegisterMode);
                                  _errorMessage = "";
                                  _successMessage = "";
                                });
                              },
                              child: Text(
                                _isRegisterMode
                                    ? "Already have an account? Login"
                                    : "Don't have an account? Register",
                                style: TextStyle(color: Colors.indigo[800], fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper function to create a text field
  Widget _buildTextField(TextEditingController controller, String label, {bool isPassword = false, bool isEmail = false}) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label cannot be empty";
        }
        return null;
      },
    );
  }
}

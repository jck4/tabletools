import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tabletools/services/auth_service.dart';
import 'package:tabletools/services/api_service.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    try {
      final profileData = await ApiService.fetchProfile();
      setState(() {
        _name = profileData['name'];
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Failed to load profile: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSaving = true;
      });

      try {
        await ApiService.updateProfile({"name": _name});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        print("❌ Failed to update profile: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile')),
        );
      } finally {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      initialValue: _name,
                      decoration: InputDecoration(labelText: "Name"),
                      validator: (value) =>
                          value!.isEmpty ? "Name can't be empty" : null,
                      onSaved: (value) => _name = value,
                    ),
                    SizedBox(height: 20),
                    _isSaving
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _saveProfile,
                            child: Text("Save"),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}

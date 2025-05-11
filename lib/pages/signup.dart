import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final String name = _nameController.text.trim();
    final String phone = _phoneController.text.trim();
    final String password = _passwordController.text.trim();
    final String confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || phone.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Please fill in all fields.';
      });
      return;
    }

    if (password != confirmPassword) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Passwords do not match.';
      });
      return;
    }

    final String apiUrl = 'http://10.0.2.2:8000/api/mobile/register';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'password': password,
        }),
      );


      if (response.statusCode == 200) {
        // Registration successful, go to login
        final responseData = json.decode(response.body);
        print('SignUp successful: $responseData');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        final responseData = json.decode(response.body);
        setState(() {
          _isLoading = false;
          _errorMessage = responseData['message'] ?? 'Registration failed.';
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // [Logo & UI remain unchanged...]

              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  hintText: "Enter your full name",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Contact Number",
                  hintText: "Enter your phone number",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _passwordController,
                obscureText: !_passwordVisible,
                decoration: InputDecoration(
                  labelText: "Password",
                  hintText: "Enter password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() => _passwordVisible = !_passwordVisible);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              TextField(
                controller: _confirmPasswordController,
                obscureText: !_confirmPasswordVisible,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Re-enter password",
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_confirmPasswordVisible ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),

              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),

              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF66CA6A),
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                ),
                child: Text("Already have an account? Log In"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

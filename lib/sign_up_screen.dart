// ignore_for_file: use_build_context_synchronously

import 'package:anonymous_chat/service/auth_service.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _usernameError;
  String? _fullNameError;
  String? _phoneNumberError;
  String? _passwordError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Image.asset(
                'assets/images/image_registerscreen.png',
                height: 250,
              ),
              const SizedBox(height: 40),

              // Input fields
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, color: Colors.white),
                  hintText: 'Username',
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.orange,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  errorText: _usernameError,
                ),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _fullNameController,
                decoration: InputDecoration(
                    prefixIcon:
                        const Icon(Icons.person_outline, color: Colors.white),
                    hintText: 'Full Name',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.orange,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorText: _fullNameError),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.phone, color: Colors.white),
                    hintText: 'Phone Number',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.orange,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorText: _phoneNumberError),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.orange,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    errorText: _passwordError),
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () async {
                  final String username = _usernameController.text;
                  final String fullName = _fullNameController.text;
                  final String phoneNumber = _phoneNumberController.text;
                  final String password = _passwordController.text;

                  if (username.isNotEmpty &&
                      fullName.isNotEmpty &&
                      phoneNumber.isNotEmpty &&
                      password.isNotEmpty) {
                    final response = await AuthService.registerUser(
                        username, fullName, phoneNumber, password);

                    if (response['success']) {
                      // Registration successful
                      // Navigate to home or login screen
                      Navigator.pushNamed(context, '/Login');
                    } else {
                      // Handle validation errors
                      setState(() {
                        // Clear previous errors
                        _usernameError = null;
                        _fullNameError = null;
                        _phoneNumberError = null;
                        _passwordError = null;

                        // Parse error messages from the response
                        for (var error in response['errors']) {
                          error.forEach((key, value) {
                            if (key == 'username') {
                              _usernameError = value;
                            } else if (key == 'phone_number') {
                              _phoneNumberError = value;
                            } else if (key == 'password') {
                              _passwordError = value;
                            }
                          });
                        }
                      });
                    }
                  } else {
                    // Handle form validation (e.g., show error message)
                    setState(() {
                      _usernameError = _usernameController.text.isEmpty
                          ? 'Username is required'
                          : null;
                      _fullNameError = _fullNameController.text.isEmpty
                          ? 'Full name is required'
                          : null;
                      _phoneNumberError = _phoneNumberController.text.isEmpty
                          ? 'Phone number is required'
                          : null;
                      _passwordError = _passwordController.text.isEmpty
                          ? 'Password is required'
                          : null;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.orange,
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Center(
                  child: Text(
                    'Sign Up',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Already have an account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/Login');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.black87, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

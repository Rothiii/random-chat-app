import 'package:anonymous_chat/service/auth_service.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameOrPhoneNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _usernameOrPhoneNumberError;
  String? _passwordError;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white, // Background color matching the design
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App Logo
                Image.asset(
                  'assets/images/image_loginscreen.png',
                  height: 250, // Adjust height as needed
                ),
                const SizedBox(height: 40),

                // User Login Text

                const Text(
                  'Welcome To Anonymous Chat',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Username Input Field
                TextField(
                  controller: _usernameOrPhoneNumberController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.person,
                      color: Colors.orange,
                    ),
                    hintText: 'Username Or Phone Number',
                    hintStyle: const TextStyle(color: Colors.orange),
                    filled: true,
                    fillColor: Colors.white,
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.orange,
                          width: 2.0), // No border around the field
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                    errorText: _usernameOrPhoneNumberError,
                  ),
                  style: const TextStyle(color: Colors.orange),
                ),
                const SizedBox(height: 20),

                // Password Input Field
                TextField(
                  obscureText: !_isPasswordVisible,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.orange,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.orange,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    hintText: 'Password',
                    hintStyle: const TextStyle(
                      color: Colors.orange,
                    ),
                    filled: true,
                    fillColor: Colors
                        .transparent, // Make field transparent for gradient
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Colors.orange,
                          width: 2.0), // No border around the field
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange, width: 2.0),
                    ),
                    errorText: _passwordError,
                  ),
                  style: const TextStyle(color: Colors.orange),
                ),
                const SizedBox(height: 30),

                // Login Button
                ElevatedButton(
                  onPressed: () async {
                    // Ambil input username/phone dan password
                    final usernameOrPhoneNumber =
                        _usernameOrPhoneNumberController.text;
                    final password = _passwordController.text;

                    setState(() {
                      // Reset error messages
                      _usernameOrPhoneNumberError =
                          usernameOrPhoneNumber.isEmpty
                              ? 'Username or phone number is required'
                              : null;
                      _passwordError =
                          password.isEmpty ? 'Password is required' : null;
                    });

                    if (usernameOrPhoneNumber.isEmpty || password.isEmpty)
                      return;

                    final response = await AuthService.loginUser(
                        usernameOrPhoneNumber, password);

                    if (response['success']) {
                      // Handle successful login
                      Navigator.pushNamed(context, '/Home');
                    } else {
                      setState(() {
                        _usernameOrPhoneNumberError = null;
                        _passwordError = null;

                        if (response['errors'] != null) {
                          // Error validation dari server
                          for (var error in response['errors']) {
                            error.forEach((key, value) {
                              if (key == 'username') {
                                _usernameOrPhoneNumberError = value;
                              } else if (key == 'password') {
                                _passwordError = value;
                              }
                            });
                          }
                        } else if (response['status'] != 'VALIDATION_ERROR' &&
                            response['tags'] != null &&
                            response['tags'].isNotEmpty) {
                          // Error status dari server
                          if (response['tags'][0] ==
                              'username_or_phone_number') {
                            _usernameOrPhoneNumberError = response['message'];
                          } else if (response['tags'][0] == 'password') {
                            _passwordError = response['message'];
                          }
                        }
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.orange,
                    backgroundColor: Colors.black87, // Text color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Sign Up Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Handle sign up navigation
                        Navigator.pushNamed(context, '/SignUp');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  "Or",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Login as Guest Button
                TextButton(
                  onPressed: () {
                    // Handle login as guest
                    Navigator.pushNamed(context, '/Home');
                  },
                  child: const Text(
                    'Login as Guest',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

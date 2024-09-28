// import 'package:chat_with_stranger/Screens/Homescreen.dart';
import 'package:anonymous_chat/login_screen.dart';
import 'package:anonymous_chat/sign_up_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      // home: HomeScreen(),
      home: LoginScreen(),
    );
  }
}

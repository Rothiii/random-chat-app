import 'package:anonymous_chat/chat_anonym_screen.dart';
import 'package:anonymous_chat/chat_bot_screen.dart';
import 'package:anonymous_chat/home.dart';
import 'package:anonymous_chat/login_screen.dart';
import 'package:anonymous_chat/onboarding_screen.dart';
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
      // home: const LoginScreen(),
      routes: {
        '/': (context) => const OnboardingScreen(),
        '/Login': (context) => const LoginScreen(),
        '/SignUp': (context) => const SignUpScreen(),
        '/Home': (context) => HomeScreen(),
        '/ChatBot': (context) => const ChatBotScreen(),
        '/ChatAnonym': (context) => const ChatAnonymScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:anonymous_chat/utils/shared_preferences_manager.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final SharedPreferencesManager prefManager = SharedPreferencesManager();

  Future<void> _navigateToAnonymousChat(BuildContext context) async {
    final isLoggedIn = await prefManager.isLoggedIn();

    if (isLoggedIn) {
      Navigator.pushNamed(context, '/ChatAnonym');
    } else {
      // Show dialog if not logged in
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Anda Belum Login"),
            content: const Text(
                "Silakan login terlebih dahulu untuk mengakses chat ini."),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pushNamed(context, '/Login'); // Navigate to login
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future<List<String>> _getUserData() async {
    final userData = await prefManager.getUserData();
    return userData;
  }

  Future<void> _logout(BuildContext context) async {
    await prefManager.deleteToken();
    await prefManager.deleteIsLoggedIn();
    await prefManager.deleteUserData();
    Navigator.pushNamedAndRemoveUntil(context, '/Login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // App bar with logo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/anonymous_chat_logo.png',
                  height: 50,
                  width: 50,
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting section with dynamic user name
                    FutureBuilder<List<String>>(
                      future: _getUserData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator(); // Sementara loading
                        } else if (snapshot.hasError) {
                          // Tangani error jika ada
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData &&
                            snapshot.data!.isNotEmpty) {
                          final userData = snapshot.data!;
                          final userName =
                              userData[0].isNotEmpty ? userData[0] : 'Guest';
                          return Text(
                            'Hello, $userName',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          );
                        } else {
                          return const Text(
                            'Hello, New User!',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome Back!!\nWhat do you want to do today?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Option to meet new people
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/images/image_anonym.png',
                          height: 100,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Meet new people in\nthe chat',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                _navigateToAnonymousChat(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Option to talk to bot
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image.asset(
                          'assets/images/bot.jpg',
                          height: 100,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Make a conversation\nwith our chat bot',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/ChatBot');
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  )),
                              child: const Text(
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    // Footer: note and logout button
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(color: Colors.black),
                        const SizedBox(height: 16),
                        const Text(
                          'Note:\nAll chat is temporary, when you exit all chat will be deleted',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              _logout(context); // Handle logout
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0, vertical: 16.0),
                            ),
                            child: const Text(
                              'LOGOUT',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

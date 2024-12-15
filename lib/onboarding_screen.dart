import 'package:anonymous_chat/login_screen.dart';
import 'package:anonymous_chat/utils/shared_preferences_manager.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  SharedPreferencesManager prefManager = SharedPreferencesManager();

  final PageController _pageController = PageController();
  int currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'imagePath': 'assets/images/ob_1.png',
      'heading': 'Welcome to the App!',
      'description': 'Discover new features and explore the app.',
    },
    {
      'imagePath': 'assets/images/ob_2.png',
      'heading': 'Fastest way to chat with someone new!',
      'description': 'Find new people, Chat with random people and make new friends.',
    },
    {
      'imagePath': 'assets/images/ob_3.png',
      'heading': 'Find Best Conversations With Our Chat Bot!',
      'description': 'Find the perfect conversation to solve for your problem and make the day remarkable.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigateToLogin(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // mulai dari kanan
          const end = Offset.zero; // berakhir di posisi normal
          const curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    prefManager.isLoggedIn().then((isLoggedIn) {
      if (isLoggedIn) {
        navigateToLogin(context);
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (currentPage < onboardingData.length - 1)
            TextButton(
              onPressed: () => navigateToLogin(context),
              child: const Text("Skip", style: TextStyle(color: Colors.black)),
            ),
        ],
      ),
      body: PageView.builder(                        
        controller: _pageController,
        onPageChanged: (int page) {
          setState(() {
            currentPage = page;
          });
        },
        itemCount: onboardingData.length,
        itemBuilder: (context, index) {
          final data = onboardingData[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(data['imagePath']!, height: 250),
                const SizedBox(height: 20),
                Text(
                  data['heading']!,
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  data['description']!,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Dots Indicator
            Row(
              children: List.generate(
                onboardingData.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage == index ? Colors.orange : Colors.grey,
                  ),
                ),
              ),
            ),
            // Next Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                if (currentPage == onboardingData.length - 1) {
                  navigateToLogin(context);
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                }
              },
              child: currentPage == onboardingData.length - 1
                  ? const Text("Get Started")
                  : const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }
}

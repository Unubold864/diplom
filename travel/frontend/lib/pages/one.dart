import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white, // Solid white background
              Colors.white.withOpacity(0.9), // Slight gradient for depth
            ],
          ),
        ),
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: "Explore Destinations",
              body: "Discover historical and scenic places effortlessly.",
              image: _buildLottieAnimation('assets/3.json'),
              decoration: pageDecoration(),
            ),
            PageViewModel(
              title: "Plan Your Trip",
              body: "Get personalized recommendations and itineraries.",
              image: _buildLottieAnimation('assets/2.json'),
              decoration: pageDecoration(),
            ),
            PageViewModel(
              title: "Start Your Journey",
              body: "Let’s begin an unforgettable adventure together!",
              image: _buildLottieAnimation('assets/1.json'),
              decoration: pageDecoration(),
            ),
          ],
          onDone: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          onSkip: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Login()),
            );
          },
          showSkipButton: true,
          skip: _buildButton("Skip"),
          next: _buildButton("Next"),
          done: _buildButton("Done"),
          dotsDecorator: DotsDecorator(
            size: Size(8, 8), // Smaller dots
            color: Colors.grey.shade300,
            activeSize: Size(20, 8), // Smaller active dot
            activeColor: persianGreen, // Use Persian Green for active dot
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded active dot
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation(String assetPath) {
    return Center(
      child: Lottie.asset(
        assetPath,
        width: 250, // Smaller animation size
        height: 250,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: persianGreen, // Use Persian Green for buttons
        borderRadius: BorderRadius.circular(24), // Rounded corners
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600, // Semi-bold for better readability
        ),
      ),
    );
  }

  PageDecoration pageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: persianGreen, // Use Persian Green for titles
      ),
      bodyTextStyle: TextStyle(fontSize: 16, color: Colors.grey.shade700),
      imagePadding: EdgeInsets.all(24), // Reduced padding
      contentMargin: EdgeInsets.symmetric(horizontal: 24), // Consistent margins
      pageColor: Colors.transparent,
    );
  }
}

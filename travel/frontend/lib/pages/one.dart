import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:frontend/pages/home_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade50, Colors.purple.shade50],
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
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          onSkip: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          },
          showSkipButton: true,
          skip: _buildButton("Skip"),
          next: _buildButton("Next"),
          done: _buildButton("Done"),
          dotsDecorator: DotsDecorator(
            size: Size(10, 10),
            color: Colors.grey.shade300,
            activeSize: Size(22, 10),
            activeColor: Colors.blue,
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLottieAnimation(String assetPath) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Lottie.asset(assetPath, width: 300, height: 300),
    );
  }

  Widget _buildButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  PageDecoration pageDecoration() {
    return PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade800,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 18,
        color: Colors.grey.shade700,
      ),
      imagePadding: EdgeInsets.all(32),
      contentMargin: EdgeInsets.symmetric(horizontal: 16),
      pageColor: Colors.transparent,
    );
  }
}
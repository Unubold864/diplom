import 'package:flutter/material.dart';
import 'package:frontend/pages/login.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2196F3), // Blue at top
              Colors.white, // White at bottom
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Sun
                  Positioned(
                    top: 50,
                    right: 30,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFAB40),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  
                  // Clouds
                  Positioned(
                    top: 70,
                    left: 40,
                    child: _buildCloud(80, 40),
                  ),
                  Positioned(
                    top: 50,
                    right: 120,
                    child: _buildCloud(100, 50),
                  ),
                  Positioned(
                    top: 120,
                    left: 140,
                    child: _buildCloud(120, 60),
                  ),
                  
                  // Wave shape
                  Positioned(
                    bottom: 150,
                    child: ClipPath(
                      clipper: WaveClipper(),
                      child: Container(
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  // Person with map
                  Positioned(
                    bottom: 250,
                    child: Image.asset(
                      'assets/traveler.png', // Make sure to add this image
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
            
            // Bottom content area
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Let's Discover World",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3F51B5), // Indigo color
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Planning trips made easy! Just a small effort helps you enjoy your holiday time while getting your own.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildPageIndicator(),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCloud(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade300,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 20,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color(0xFF2196F3),
          ),
        ),
      ],
    );
  }
}

// Custom clipper for the wave shape
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    
    var firstControlPoint = Offset(size.width * 0.75, size.height * 0.3);
    var firstEndPoint = Offset(size.width * 0.5, size.height * 0.4);
    path.quadraticBezierTo(
      firstControlPoint.dx, 
      firstControlPoint.dy, 
      firstEndPoint.dx, 
      firstEndPoint.dy
    );
    
    var secondControlPoint = Offset(size.width * 0.25, size.height * 0.5);
    var secondEndPoint = Offset(0, 0);
    path.quadraticBezierTo(
      secondControlPoint.dx, 
      secondControlPoint.dy, 
      secondEndPoint.dx, 
      secondEndPoint.dy
    );
    
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
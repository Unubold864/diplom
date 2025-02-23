import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_named/ionicons_named.dart';

class TouristDetailsPage extends StatelessWidget {
  const TouristDetailsPage({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(16), // Consistent padding
          children: [
            // Image Section
            SizedBox(
              height: size.height * 0.3, // Adjusted height for a cleaner look
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Rounded corners
                child: Image.asset(
                  image,
                  fit: BoxFit.cover, // Ensures the image covers the area
                ),
              ),
            ),
            SizedBox(height: 20),

            // Start Tour Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Get Directions",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
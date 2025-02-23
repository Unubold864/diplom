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
              height: size.height * 0.35, // Adjusted height
              width: double.maxFinite,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(20),
                      ),
                      image: DecorationImage(
                        image: AssetImage(image),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(15),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            iconSize: 24, // Larger icon size
                            icon: Icon(
                              ionicons['chevron_back_outline'],
                            ), // Cleaner icon
                          ),
                          IconButton(
                            onPressed: () {},
                            iconSize: 24,
                            icon: Icon(
                              ionicons['heart_outline'],
                            ), // Cleaner icon
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                "Start Tour",
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

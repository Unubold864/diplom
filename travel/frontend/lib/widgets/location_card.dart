import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({Key? key}) : super(key: key);

  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Colors.white.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Lottie Animation
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: persianGreen.withOpacity(
                  0.1,
                ), // Persian Green background
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                // Center the Lottie animation
                child: Lottie.asset(
                  'assets/map1.json', // Replace with your Lottie file
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Location Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: persianGreen, // Persian Green icon
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Location",
                        style: GoogleFonts.lato(
                          // Replace 'lato' with the desired font family
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: persianGreen, // Persian Green text
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Улаанбаатар, Монгол",
                    style: GoogleFonts.lato(
                      // Replace 'lato' with the desired font family
                      fontSize: 16,
                      color: Colors.grey[700], // Persian Green text
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

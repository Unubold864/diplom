import 'package:flutter/material.dart';
import 'package:frontend/models/tourist_places_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_named/ionicons_named.dart';

class TouristPlaces extends StatelessWidget {
  const TouristPlaces({Key? key}) : super(key: key);

  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120, // Increased height for better visibility
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // Handle tap event
                print('Selected: ${touristPlaces[index].name}');
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 160, // Fixed width for each card
                decoration: BoxDecoration(
                  color: Colors.white, // Solid white background
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Subtle shadow
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Place Icon
                      Icon(
                        ionicons['location_outline'], // Use an icon instead of an image
                        size: 40,
                        color: persianGreen, // Persian Green icon
                      ),
                      const SizedBox(height: 8),
                      // Place Name
                      Text(
                        touristPlaces[index].name,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87, // Dark text for better contrast
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemCount: touristPlaces.length,
      ),
    );
  }
}
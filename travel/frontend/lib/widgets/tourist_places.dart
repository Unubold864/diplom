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
      height: 100, // Reduced height for better proportion
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
              borderRadius: BorderRadius.circular(40), // Adjusted border radius for smaller container
              child: Container(
                width: 80, // Smaller width for a more compact design
                height: 80, // Smaller height for a more compact design
                decoration: BoxDecoration(
                  color: Colors.white, // Solid white background
                  shape: BoxShape.circle, // Make the background circular
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Subtle shadow
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2), // Smaller offset
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8), // Reduced padding for smaller container
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Place Icon
                      Icon(
                        ionicons['location_outline'], // Use an icon instead of an image
                        size: 24, // Smaller icon size
                        color: persianGreen, // Persian Green icon
                      ),
                      const SizedBox(height: 4), // Reduced spacing
                      // Place Name
                      Text(
                        touristPlaces[index].name,
                        style: GoogleFonts.poppins(
                          fontSize: 11, // Smaller font size
                          fontWeight: FontWeight.w600, // Semi-bold for better readability
                          color: Colors.black87, // Dark text for better contrast
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2, // Allow text to wrap to two lines
                        overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 20), // Increased space between items
        itemCount: touristPlaces.length,
      ),
    );
  }
}
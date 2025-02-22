import 'package:flutter/material.dart';
import 'package:frontend/models/nerby_places_model.dart';
import 'package:google_fonts/google_fonts.dart';

class NerbyPlaces extends StatelessWidget {
  const NerbyPlaces({Key? key}) : super(key: key);

  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160, // Fixed height for the horizontal scroll view
      child: ListView.separated(
        physics: const BouncingScrollPhysics(), // Smooth scrolling
        scrollDirection: Axis.horizontal, // Horizontal scroll
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: nearbyPlaces.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          return Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                // Handle tap event
              },
              child: Container(
                width: 280, // Fixed width for each card
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
                  child: Row(
                    children: [
                      // Image
                      Hero(
                        tag: 'nearby_${nearbyPlaces[index].image}',
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            nearbyPlaces[index].image,
                            height: double.maxFinite,
                            width: 120,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                height: double.maxFinite,
                                width: 120,
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.error_outline,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title
                            Text(
                              nearbyPlaces[index].name ??
                                  'Unknown', // Use the name from the model
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color:
                                    Colors
                                        .black87, // Dark text for better contrast
                              ),
                            ),
                            const SizedBox(height: 4),
                            // Subtitle
                            Text(
                              nearbyPlaces[index].location ??
                                  'Unknown location', // Use the location from the model
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Distance (Replaced with a simple horizontal layout)
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: persianGreen, // Persian Green icon
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "2.5 km", // Replace with dynamic distance if needed
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            // Rating and Price
                            Row(
                              children: [
                                // Rating
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.yellow.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow.shade700,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        nearbyPlaces[index].rating
                                            .toString(), // Use the rating from the model
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                // Price
                                RichText(
                                  text: TextSpan(
                                    style: GoogleFonts.poppins(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: persianGreen, // Persian Green text
                                    ),
                                    text:
                                        "\$${nearbyPlaces[index].price}", // Use the price from the model
                                    children: [
                                      TextSpan(
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.grey[600],
                                        ),
                                        text: "/Person",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

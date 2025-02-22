import 'package:flutter/material.dart';
import 'package:frontend/models/tourist_places_model.dart';

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
                  gradient: LinearGradient(
                    colors: [
                      persianGreen.withOpacity(0.1), // Light Persian Green
                      Colors.white.withOpacity(0.8), // Slightly transparent white
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
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
                      // Place Image
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(touristPlaces[index].image),
                      ),
                      const SizedBox(height: 8),
                      // Place Name
                      Text(
                        touristPlaces[index].name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: persianGreen, // Persian Green text
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
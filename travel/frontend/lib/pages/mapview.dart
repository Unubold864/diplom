// Basic Map Screen (You'll need to implement your actual map functionality)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Map View",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF00A896),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.map,
              size: 100,
              color: const Color(0xFF00A896),
            ),
            const SizedBox(height: 20),
            Text(
              "Map View Would Appear Here",
              style: GoogleFonts.poppins(fontSize: 18),
            ),
            // You would replace this with your actual map widget
            // For example: GoogleMap(initialCameraPosition: _kGooglePlex),
          ],
        ),
      ),
    );
  }
}
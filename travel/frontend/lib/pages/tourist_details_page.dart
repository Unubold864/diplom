import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TouristDetailsPage extends StatelessWidget {
  const TouristDetailsPage({
    super.key,
    required this.image,
    required this.name,
    required this.location,
    required this.description,
    required this.phoneNumber,
    required this.hotelRating,
  });

  final String image;
  final String name;
  final String location;
  final String description;
  final String phoneNumber;
  final String hotelRating;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16), // Consistent padding
          children: [
            // Image Section
            SizedBox(
              height: size.height * 0.3, // Adjusted height for a cleaner look
              width: double.maxFinite,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Rounded corners
                child: Image.network(
                  image,
                  fit: BoxFit.cover, // Ensures the image covers the area
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.error_outline, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Place Name
            Text(
              name,
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            const SizedBox(height: 10),

            // Location Section
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  location,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Description Section
            Text(
              description,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.blueGrey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Phone Section
            Row(
              children: [
                const Icon(
                  Icons.phone,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  phoneNumber,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Hotel Rating Section
            Row(
              children: [
                const Icon(
                  Icons.hotel,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  hotelRating,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // Start Tour Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                elevation: 0,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(
                "Эхлэх",
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

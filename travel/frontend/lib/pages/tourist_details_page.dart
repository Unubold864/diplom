import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart'; // For icons

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

            // Place Name
            Text(
              "Гранд Плаза Хотель",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey[900],
              ),
            ),
            SizedBox(height: 10),

            // Location Section
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "Улаанбаатар, Монгол",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Description Section
            Text(
              "Гранд Плаза Хотель нь тав тухтай орчин, орчин үеийн тоног төхөөрөмжөөр тоноглогдсон, Улаанбаатар хотын төвд байрладаг. Энд амралтаа сайхан өнгөрүүлээрэй.",
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.blueGrey[600],
                height: 1.5,
              ),
            ),
            SizedBox(height: 20),

            // Phone Section
            Row(
              children: [
                Icon(
                  Icons.phone,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "+976 1234 5678",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),

            // Hotel Icon Section
            Row(
              children: [
                Icon(
                  Icons.hotel,
                  color: Colors.blueAccent,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text(
                  "5 одны зочид буудал",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.blueGrey[700],
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),

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
// hotel.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HotelPage extends StatelessWidget {
  const HotelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Зочид буудлууд',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Center(
        child: Text(
          'Зочид буудлын хуудас',
          style: GoogleFonts.poppins(fontSize: 20),
        ),
      ),
    );
  }
}
// parking.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ParkingPage extends StatefulWidget {
  final int placeId;

  const ParkingPage({super.key, required this.placeId});

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Зогсоол',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: Center(
        child: Text(
          'Зогсоолын мэдээлэл энд гарна',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      ),
    );
  }
}
// parking.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ParkingPage extends StatefulWidget {
  final int placeId;

  const ParkingPage({super.key, required this.placeId});

  @override
  State<ParkingPage> createState() => _ParkingPageState();
}

class _ParkingPageState extends State<ParkingPage> {
  List<Map<String, dynamic>> _parkings = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchParkings();
  }

  Future<void> _fetchParkings() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/api/parkings/?place=${widget.placeId}',
        ),
        headers: {'Accept': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as List;
        setState(() {
          _parkings =
              data
                  .map(
                    (parking) => {
                      'name': parking['name'] ?? 'Зогсоол',
                      'type': parking['type'] ?? 'Төрөл тодорхойгүй',
                      'capacity': parking['capacity'] ?? 'Томъёогүй',
                      'price': parking['price'] ?? 'Үнэгүй',
                      'distance': parking['distance'] ?? 'Зай тодорхойгүй',
                      'isCovered': parking['is_covered'] ?? false,
                    },
                  )
                  .toList();
        });
      } else {
        setState(() {
          _errorMessage =
              'Мэдээлэл авахад алдаа гарлаа: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Алдаа: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Зогсоолууд', style: GoogleFonts.poppins())),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _parkings.isEmpty
              ? const Center(child: Text('Зогсоол олдсонгүй'))
              : ListView.builder(
                itemCount: _parkings.length,
                itemBuilder: (context, index) {
                  final parking = _parkings[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            parking['name'],
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.local_parking, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Төрөл: ${parking['type']}',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.car_rental, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Багтаамж: ${parking['capacity']}',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.attach_money, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Үнэ: ${parking['price']}',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.directions_walk, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                'Зай: ${parking['distance']}',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.roofing, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                parking['isCovered']
                                    ? 'Дээвэртэй'
                                    : 'Дээвэргүй',
                                style: GoogleFonts.poppins(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}

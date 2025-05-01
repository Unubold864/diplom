import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

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
  final Color primaryColor = const Color(0xFF00A896);
  final Color backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _fetchParkings();
  }

  Future<void> _fetchParkings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    try {
      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/api/parkings/?place=${widget.placeId}',
        ),
        headers: {
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as List;
        setState(() {
          _parkings =
              data.map((parking) {
                return {
                  'name': parking['name'] ?? 'Зогсоол',
                  'type':
                      parking['type_display'] ??
                      parking['type'] ??
                      'Төрөл тодорхойгүй',
                  'capacity': parking['capacity']?.toString() ?? 'Тодорхойгүй',
                  'price': parking['price'] ?? 'Үнэгүй',
                  'distance': parking['distance'] ?? 'Зай тодорхойгүй',
                  'isCovered': parking['is_covered'] ?? false,
                  'image':
                      parking['image_url'] ?? 'https://via.placeholder.com/150',
                };
              }).toList();
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
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Зогсоолууд',
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.black87,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchParkings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Дахин оролдох',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_parkings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_parking, size: 50, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Зогсоол олдсонгүй',
              style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _parkings.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildParkingCard(_parkings[index]),
    );
  }

  Widget _buildParkingCard(Map<String, dynamic> parking) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              children: [
                Image.network(
                  parking['image'],
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 140,
                      color: Colors.grey[100],
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        height: 140,
                        color: Colors.grey[200],
                        child: Center(
                          child: Icon(
                            Icons.local_parking,
                            size: 50,
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '4.5', // Replace with actual rating if available
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
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
                const SizedBox(height: 12),
                _buildParkingDetailRow(
                  Icons.local_parking,
                  'Төрөл: ${parking['type']}',
                ),
                const SizedBox(height: 8),
                _buildParkingDetailRow(
                  Icons.car_rental,
                  'Багтаамж: ${parking['capacity']}',
                ),
                const SizedBox(height: 8),
                _buildParkingDetailRow(
                  Icons.attach_money,
                  'Үнэ: ${parking['price']}',
                ),
                const SizedBox(height: 8),
                _buildParkingDetailRow(
                  Icons.directions_walk,
                  'Зай: ${parking['distance']}',
                ),
                const SizedBox(height: 8),
                _buildParkingDetailRow(
                  Icons.roofing,
                  parking['isCovered'] ? 'Дээвэртэй' : 'Дээвэргүй',
                  isCovered: parking['isCovered'],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle navigation or action
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Зарлага хийх',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildParkingDetailRow(IconData icon, String text, {bool? isCovered}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color:
              isCovered != null
                  ? (isCovered ? Colors.green : Colors.orange)
                  : primaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey[700]),
        ),
      ],
    );
  }
}

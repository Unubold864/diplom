
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HotelPage extends StatefulWidget {
  final int placeId;

  const HotelPage({super.key, required this.placeId});

  @override
  State<HotelPage> createState() => _HotelPageState();
}

class _HotelPageState extends State<HotelPage> {
  List<Map<String, dynamic>> _hotels = [];
  bool _isLoading = true;
  String? _errorMessage;
  final Color primaryColor = const Color(0xFF00A896);

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    if (token == null) {
      setState(() {
        _errorMessage = 'Access token not found.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/hotels/?place=${widget.placeId}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json; charset=utf-8',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as List;
        setState(() {
          _hotels = data.map((hotel) => {
            'name': hotel['name'],
            'rating': hotel['rating']?.toDouble() ?? 0.0,
            'price': hotel['price'] ?? 'Үнэлгээ байхгүй',
            'image': _getImageUrl(hotel),
            'description': hotel['description'] ?? 'Тайлбар байхгүй',
            'address': hotel['address'] ?? 'Хаяг байхгүй',
            'phone': hotel['phone'] ?? 'Утасны дугаар байхгүй',
          }).toList();
        });
      } else {
        setState(() {
          _errorMessage = 'Мэдээлэл авахад алдаа гарлаа: ${response.statusCode}';
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

  String _getImageUrl(Map<String, dynamic> hotel) {
    final url = hotel['image_url'] ?? hotel['image'];
    if (url == null) return 'https://via.placeholder.com/150';
    if (url.startsWith('/')) return 'http://127.0.0.1:8000$url';
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Зочид буудлууд', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF00A896))),
      );
    }
    if (_errorMessage != null) {
      return Center(child: Text(_errorMessage!, style: GoogleFonts.poppins(fontSize: 16)));
    }
    if (_hotels.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hotel, size: 50, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Зочид буудал олдсонгүй', style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600])),
        ],
      ));
    }
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _hotels.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) => _buildHotelCard(_hotels[index]),
    );
  }

  Widget _buildHotelCard(Map<String, dynamic> hotel) {
    return GestureDetector(
      onTap: () => _showHotelDetails(context, hotel),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                hotel['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Center(child: Icon(Icons.hotel, size: 50)),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(hotel['name'], style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined, size: 16, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(child: Text(hotel['address'], style: GoogleFonts.poppins(fontSize: 14))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(hotel['price'], style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: primaryColor)),
                      TextButton(
                        onPressed: () {
                          launchUrl(Uri(scheme: 'tel', path: hotel['phone']));
                        },
                        child: Row(
                          children: [
                            Icon(Icons.call, color: primaryColor, size: 16),
                            const SizedBox(width: 4),
                            Text('Утасдах', style: GoogleFonts.poppins(color: primaryColor)),
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
    );
  }

  void _showHotelDetails(BuildContext context, Map<String, dynamic> hotel) {
    // You can copy the full bottom sheet implementation from previous versions
    // depending on your UX design needs
  }
}

// hotel.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

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

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/hotels/?place=${widget.placeId}'),
        headers: {'Accept': 'application/json; charset=utf-8'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as List;
        print('API Response: $data'); // Debug print

        setState(() {
          _hotels =
              data.map((hotel) {
                // Debug print each hotel's image URL
                print(
                  'Hotel ${hotel['name']} image: ${hotel['image_url'] ?? hotel['image']}',
                );

                return {
                  'name': hotel['name'],
                  'rating': hotel['rating']?.toDouble() ?? 0.0,
                  'price': hotel['price'] ?? 'Үнэлгээ байхгүй',
                  'image': _getImageUrl(hotel), // Use helper function
                  'description': hotel['description'] ?? 'Тайлбар байхгүй',
                  'address': hotel['address'] ?? 'Хаяг байхгүй',
                  'phone': hotel['phone'] ?? 'Утасны дугаар байхгүй',
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

  String _getImageUrl(Map<String, dynamic> hotel) {
    // Try different possible image fields
    final url = hotel['image_url'] ?? hotel['image'];

    if (url == null) {
      return 'https://via.placeholder.com/150';
    }

    // If URL is relative, make it absolute
    if (url.startsWith('/')) {
      return 'http://127.0.0.1:8000$url';
    }

    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Зочид буудлууд', style: GoogleFonts.poppins()),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : _hotels.isEmpty
              ? const Center(child: Text('Зочид буудал олдсонгүй'))
              : ListView.builder(
                itemCount: _hotels.length,
                itemBuilder: (context, index) {
                  final hotel = _hotels[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              hotel['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              loadingProgress
                                                  .expectedTotalBytes!
                                          : null,
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                print('Image load error: $error');
                                print('URL: ${hotel['image']}');
                                return const Icon(Icons.hotel, size: 60);
                              },
                            ),
                          ),
                          title: Text(
                            hotel['name'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(hotel['address']),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(' ${hotel['rating']}'),
                                  const Spacer(),
                                  Text(
                                    hotel['price'],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          onTap: () {
                            _showHotelDetails(context, hotel);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }

  void _showHotelDetails(BuildContext context, Map<String, dynamic> hotel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Text(
                  hotel['name'],
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    hotel['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Icon(Icons.hotel, size: 50),
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      hotel['rating'].toString(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      hotel['price'],
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Хаяг: ${hotel['address']}',
                  style: GoogleFonts.poppins(fontSize: 16),
                ),
                const SizedBox(height: 16),
                Text(
                  hotel['description'],
                  style: GoogleFonts.poppins(fontSize: 15, height: 1.5),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: hotel['phone'],
                      );
                      launchUrl(launchUri);
                    },
                    icon: const Icon(Icons.call),
                    label: const Text('Утасдах'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00A896),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

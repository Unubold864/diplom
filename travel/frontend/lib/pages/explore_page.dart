import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  late GoogleMapController _mapController;
  LatLng _initialPosition = const LatLng(47.918873, 106.917701);
  final Color persianGreen = const Color(0xFF00A896);

  List<Map<String, dynamic>> _places = [];

  Set<Marker> get _markers =>
      _places.map((place) {
        return Marker(
          markerId: MarkerId(place['name']),
          position: place['position'],
          infoWindow: InfoWindow(
            title: place['name'],
            snippet: 'Үнэлгээ: ${place['rating']}',
          ),
        );
      }).toSet();

  Future<void> _fetchTopRatedNearbyPlaces() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _initialPosition = LatLng(position.latitude, position.longitude);
      });

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) {
        print("❌ Access token байхгүй байна!");
        return;
      }

      final url = Uri.parse(
        'http://127.0.0.1:8000/api/top_rated_nearby_places/?lat=${position.latitude}&lon=${position.longitude}',
      );

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List data = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _places =
              data.map((place) {
                return {
                  'name': place['name'],
                  'position': LatLng(place['latitude'], place['longitude']),
                  'rating': place['rating'],
                };
              }).toList();
        });
      } else {
        print('⚠️ Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Error fetching places: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchTopRatedNearbyPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: persianGreen,
        elevation: 4,
        centerTitle: true,
        title: Text(
          '🌍 Хайх газар',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          // 🌐 Google Map
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14,
                ),
                markers: _markers,
                onMapCreated: (controller) => _mapController = controller,
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child:
                _places.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _places.length,
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 8,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                            leading: const CircleAvatar(
                              radius: 24,
                              backgroundColor: Color(0xFF00A896),
                              child: Icon(Icons.place, color: Colors.white),
                            ),
                            title: Text(
                              place['name'],
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${place['rating']}',
                                  style: GoogleFonts.poppins(fontSize: 13),
                                ),
                              ],
                            ),
                            onTap: () {
                              _mapController.animateCamera(
                                CameraUpdate.newLatLng(place['position']),
                              );
                            },
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

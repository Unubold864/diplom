import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

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

      final url = Uri.parse(
        'http://10.0.2.2:8000/api/top_rated_nearby_places/?lat=${position.latitude}&lon=${position.longitude}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('🌍 Хайх газар'),
        backgroundColor: persianGreen,
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 14,
                ),
                markers: _markers,
                onMapCreated: (controller) => _mapController = controller,
                myLocationEnabled: true,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            flex: 1,
            child:
                _places.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _places.length,
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        return Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: const CircleAvatar(
                              backgroundColor: Color(0xFF00A896),
                              child: Icon(Icons.place, color: Colors.white),
                            ),
                            title: Text(
                              place['name'],
                              style: GoogleFonts.poppins(
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
                                Text('${place['rating']}'),
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

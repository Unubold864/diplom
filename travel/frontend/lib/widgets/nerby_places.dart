import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/models/nerby_places_model.dart';
import 'package:frontend/pages/tourist_details_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NerbyPlaces extends StatefulWidget {
  const NerbyPlaces({super.key});

  @override
  _NerbyPlacesState createState() => _NerbyPlacesState();
}

class _NerbyPlacesState extends State<NerbyPlaces> {
  late Future<List<NerbyPlacesModel>> _nearbyPlacesFuture;

  @override
  void initState() {
    super.initState();
    _nearbyPlacesFuture = fetchNearbyPlaces();
  }

  Future<List<NerbyPlacesModel>> fetchNearbyPlaces() async {
    try {
      Position position = await _getCurrentLocation();
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      print("TOKEN: $token");
      if (token == null) throw Exception('Access token not found');

      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/api/nearby_places/?lat=${position.latitude}&lon=${position.longitude}',
        ),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(utf8Decoded);

        return data.map((item) {
          var place = NerbyPlacesModel.fromJson(item);
          place.distance ??= calculateDistance(place, position);
          return place;
        }).toList();
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching nearby places: $e');
      return [];
    }
  }

  double calculateDistance(NerbyPlacesModel place, Position position) {
    try {
      double lat = place.latitude ?? 0.0;
      double lon = place.longitude ?? 0.0;
      return Geolocator.distanceBetween(
            position.latitude,
            position.longitude,
            lat,
            lon,
          ) /
          1000;
    } catch (e) {
      print('Distance calc error: $e');
      return 0.0;
    }
  }

  Future<Position> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw Exception('Location services disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        throw Exception('Location permission denied.');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<NerbyPlacesModel>>(
            future: _nearbyPlacesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Алдаа: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: NearbyPlaceCard(place: snapshot.data![index]),
                    );
                  },
                );
              } else {
                return const Center(child: Text('Ойролцоо газар олдсонгүй'));
              }
            },
          ),
        ),
      ],
    );
  }
}

class NearbyPlaceCard extends StatelessWidget {
  final NerbyPlacesModel place;
  const NearbyPlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => _navigateToDetails(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  _buildPlaceImage(),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(bottom: 8, left: 8, child: _buildDistanceBadge()),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place.name ?? 'Нэргүй газар',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      place.location ?? 'Байршил тодорхойгүй',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber.shade600,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            place.rating?.toStringAsFixed(1) ?? '-.-',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.blue.shade400,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceImage() {
    return place.image != null && place.image!.isNotEmpty
        ? Image.network(
            place.image!,
            height: 120,
            width: 180,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildPlaceholderImage(),
          )
        : _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 120,
      width: 180,
      color: Colors.grey.shade200,
      child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
    );
  }

  Widget _buildDistanceBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, color: Colors.blue.shade600, size: 14),
          const SizedBox(width: 4),
          Text(
            place.distance != null && place.distance! > 0
                ? '${place.distance!.toStringAsFixed(1)} км'
                : 'Ойрхон',
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    final allImages = [
      if (place.image != null && place.image!.isNotEmpty) place.image!,
      ...place.images.where((img) => img.isNotEmpty),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TouristDetailsPage(
          image: place.image ?? (allImages.isNotEmpty ? allImages.first : ''),
          images: allImages,
          name: place.name ?? 'Unknown Place',
          location: place.location ?? 'Unknown Location',
          description: place.description ?? 'No description available',
          phoneNumber: place.phoneNumber ?? 'Not available',
          rating: place.rating ?? 0.0,
          hotelRating: place.hotelRating ?? '0.0',
          placeId: place.id ?? 0,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/models/nerby_places_model.dart';
import 'package:frontend/pages/tourist_details_page.dart'; // Import the details page
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class NerbyPlaces extends StatefulWidget {
  const NerbyPlaces({Key? key}) : super(key: key);

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
      print('Current position: ${position.latitude}, ${position.longitude}');

      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/api/nearby_places/?lat=${position.latitude}&lon=${position.longitude}',
        ),
        headers: {'Accept-Charset': 'utf-8'},
      );

      print('API response status: ${response.statusCode}');
      print('API response body: ${response.body}');

      if (response.statusCode == 200) {
        final utf8Decoded = utf8.decode(response.bodyBytes);
        List<dynamic> data = json.decode(utf8Decoded);

        List<NerbyPlacesModel> places = data.map((item) {
          print('Place item: $item');
          var place = NerbyPlacesModel.fromJson(item);
          
          // Debug image URL
          print('Place image URL: ${place.image}');

          // Only calculate distance if not provided by API
          if (place.distance == null) {
            place.distance = calculateDistance(place, position);
            print('Locally calculated distance for ${place.name}: ${place.distance} km');
          } else {
            print('Using API distance for ${place.name}: ${place.distance} km');
          }
          
          return place;
        }).toList();
        
        return places;
      } else {
        throw Exception(
          'Failed to load nearby places (Status code: ${response.statusCode})',
        );
      }
    } catch (e) {
      print('Error fetching nearby places: $e');
      return [];
    }
  }

  double calculateDistance(NerbyPlacesModel place, Position position) {
    // Use default coordinates if place coordinates are missing
    double placeLat = place.latitude ?? 0.0;
    double placeLng = place.longitude ?? 0.0;
    
    // Check if we have valid coordinates
    if (placeLat == 0.0 && placeLng == 0.0) {
      print('Missing coordinates for ${place.name}');
      return 0.0;
    }
    
    try {
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        placeLat,
        placeLng,
      );
      
      double distanceInKm = distanceInMeters / 1000; // Convert to km
      print('Distance calculated for ${place.name}: $distanceInKm km');
      return distanceInKm;
    } catch (e) {
      print('Distance calculation error for ${place.name}: $e');
      return 0.0;
    }
  }

  Future<Position> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          throw Exception('Location permission is denied');
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      print('Got position: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      print('Error getting location: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: FutureBuilder<List<NerbyPlacesModel>>(
        future: _nearbyPlacesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 40),
                  SizedBox(height: 8),
                  Text(
                    'Алдаа гарлаа: ${snapshot.error}',
                    style: GoogleFonts.poppins(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final nearbyPlaces = snapshot.data!;
            return ListView.separated(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: nearbyPlaces.length,
              separatorBuilder: (context, index) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                return _NearbyPlaceCard(place: nearbyPlaces[index]);
              },
            );
          } else {
            return Center(
              child: Text(
                'Ойролцоо газар олдсонгүй',
                style: GoogleFonts.poppins(),
              ),
            );
          }
        },
      ),
    );
  }
}

class _NearbyPlaceCard extends StatelessWidget {
  final NerbyPlacesModel place;

  const _NearbyPlaceCard({Key? key, required this.place}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToDetails(context),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Зураг
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: place.image != null && place.image!.isNotEmpty
                      ? Image.network(
                          place.image!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Image error for ${place.name}: $error');
                            return Container(
                              height: 100,
                              color: Colors.grey[200],
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 30,
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Зураг ачаалсангүй',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                      : Container(
                          height: 100,
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_not_supported,
                                color: Colors.grey,
                                size: 30,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Зураг байхгүй',
                                style: TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name ?? 'Нэргүй газар',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        place.location ?? 'Байршил тодорхойгүй',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.green,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            place.distance != null && place.distance! > 0
                                ? '${place.distance!.toStringAsFixed(1)} км'
                                : 'Ойрхон',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.yellow[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            SizedBox(width: 4),
                            Text(
                              place.rating?.toStringAsFixed(1) ?? '-.-',
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToDetails(BuildContext context) {
    // Navigate to tourist details page similar to recommended places
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TouristDetailsPage(
          image: place.image ?? 'https://via.placeholder.com/400',
          name: place.name ?? 'Unknown Place',
          location: place.location ?? 'Unknown Location',
          description: place.description ?? 'No description available for this place.',
          phoneNumber: '+976 12345678', // Default phone number or get from API if available
          hotelRating: place.rating?.toString() ?? '0.0',
        ),
      ),
    );
  }
}
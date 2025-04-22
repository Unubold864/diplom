import 'package:flutter/material.dart';
import 'package:frontend/models/nerby_places_model.dart';
import 'package:frontend/pages/tourist_details_page.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

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

        List<NerbyPlacesModel> places =
            data.map((item) {
              print('Place item: $item');
              var place = NerbyPlacesModel.fromJson(item);

              if (place.distance == null) {
                place.distance = calculateDistance(place, position);
                print(
                  'Calculated distance for ${place.name}: ${place.distance} km',
                );
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
    double placeLat = place.latitude ?? 0.0;
    double placeLng = place.longitude ?? 0.0;

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

      double distanceInKm = distanceInMeters / 1000;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //   child: Text(
        //     'Ойролцоох газрууд',
        //     style: GoogleFonts.poppins(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //       color: Colors.black87,
        //     ),
        //   ),
        // ),
        const SizedBox(height: 12),
        SizedBox(
          height: 220,
          child: FutureBuilder<List<NerbyPlacesModel>>(
            future: _nearbyPlacesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return _buildPlacesList(snapshot.data!);
              } else {
                return _buildEmptyState();
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade400, size: 40),
          const SizedBox(height: 8),
          Text(
            'Алдаа гарлаа: $error',
            style: GoogleFonts.poppins(
              color: Colors.red.shade700,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off, color: Colors.grey.shade400, size: 40),
          const SizedBox(height: 8),
          Text(
            'Ойролцоо газар олдсонгүй',
            style: GoogleFonts.poppins(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlacesList(List<NerbyPlacesModel> places) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: places.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(right: 16),
          child: _NearbyPlaceCard(place: places[index]),
        );
      },
    );
  }
}

class _NearbyPlaceCard extends StatelessWidget {
  final NerbyPlacesModel place;

  const _NearbyPlaceCard({required this.place});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToDetails(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image with gradient overlay
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
              // Content
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
                        Text(
                          place.rating?.toStringAsFixed(1) ?? '-.-',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
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
          errorBuilder: (context, error, stackTrace) {
            return _buildPlaceholderImage();
          },
        )
        : _buildPlaceholderImage();
  }

  Widget _buildPlaceholderImage() {
    return Container(
      height: 120,
      width: 180,
      color: Colors.grey.shade200,
      child: Center(
        child: Icon(
          Icons.image_not_supported,
          color: Colors.grey.shade400,
          size: 40,
        ),
      ),
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
    // Combine all images (main + gallery)
    print('Name: ${place.name}');
    print('Description being passed: ${place.description}');
    print('Description length: ${place.description?.length}');
    print('Images count: ${place.images.length}');
    final allImages = [
      if (place.image != null && place.image!.isNotEmpty) place.image!,
      ...place.images.where((img) => img.isNotEmpty),
    ];

    // Ensure we have a valid placeId
    final placeId = place.id ?? 0; // Provide default value if null

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => TouristDetailsPage(
              image:
                  place.image ?? (allImages.isNotEmpty ? allImages.first : ''),
              images: allImages,
              name: place.name ?? 'Unknown Place',
              location: place.location ?? 'Unknown Location',
              description: place.description ?? 'No description available',
              phoneNumber: place.phoneNumber ?? 'Not available',
              rating: place.rating ?? 0.0,
              hotelRating: place.rating?.toString() ?? '0.0',
              placeId: placeId, // Use the safe value here
            ),
      ),
    );
  }
}

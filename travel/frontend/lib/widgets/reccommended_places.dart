import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/models/reccommended_places_model.dart';
import 'package:frontend/pages/tourist_details_page.dart';
import 'package:ionicons_named/ionicons_named.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReccommendedPlaces extends StatefulWidget {
  const ReccommendedPlaces({super.key});

  @override
  _ReccommendedPlacesState createState() => _ReccommendedPlacesState();
}

class _ReccommendedPlacesState extends State<ReccommendedPlaces> {
  late Future<List<ReccommendedPlacesModel>> _recommendedPlacesFuture;
  List<String> _likedPlacesIds = [];
  final Color _persianGreen = const Color(0xFF00A896);

  @override
  void initState() {
    super.initState();
    _recommendedPlacesFuture = _loadRecommendedPlaces();
    _loadLikedPlaces();
  }

  Future<void> _loadLikedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _likedPlacesIds = prefs.getStringList('likedPlaces') ?? [];
    });
  }

  Future<void> _toggleLike(String placeId) async {
    if (placeId.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_likedPlacesIds.contains(placeId)) {
        _likedPlacesIds.remove(placeId);
      } else {
        _likedPlacesIds.add(placeId);
      }
    });
    await prefs.setStringList('likedPlaces', _likedPlacesIds);
  }

  Future<List<ReccommendedPlacesModel>> _loadRecommendedPlaces() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');

      if (token == null) throw Exception('Access token not found');

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/recommended_places/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept-Charset': 'utf-8',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data.map((item) => ReccommendedPlacesModel.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch places: $e');
    }
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(_persianGreen),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 40),
          const SizedBox(height: 10),
          Text('Failed to load places', style: GoogleFonts.poppins(color: Colors.red)),
          Text(error, style: GoogleFonts.poppins(color: Colors.grey), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search_off, color: Colors.grey, size: 40),
          const SizedBox(height: 10),
          Text('No recommended places found', style: GoogleFonts.poppins(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildPlacesList(List<ReccommendedPlacesModel> places) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: places.length,
      itemBuilder: (context, index) {
        final place = places[index];
        return _RecommendedPlaceCard(
          key: ValueKey(place.id),
          place: place,
          isLiked: _likedPlacesIds.contains(place.id),
          onLikePressed: () => _toggleLike(place.id),
        );
      },
      separatorBuilder: (_, __) => const SizedBox(width: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Text(
            'Recommended Places',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 280,
          child: FutureBuilder<List<ReccommendedPlacesModel>>(
            future: _recommendedPlacesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoadingIndicator();
              } else if (snapshot.hasError) {
                return _buildErrorWidget(snapshot.error.toString());
              } else if (snapshot.hasData) {
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
}

class _RecommendedPlaceCard extends StatelessWidget {
  final ReccommendedPlacesModel place;
  final bool isLiked;
  final VoidCallback onLikePressed;

  const _RecommendedPlaceCard({
    required Key key,
    required this.place,
    required this.isLiked,
    required this.onLikePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final allImages = [
      if (place.image.isNotEmpty) place.image,
      ...place.images.where((img) => img.isNotEmpty),
    ];

    return SizedBox(
      width: 240,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TouristDetailsPage(
                  image: place.image.isNotEmpty ? place.image : (allImages.isNotEmpty ? allImages.first : ''),
                  images: allImages,
                  name: place.name,
                  location: place.location,
                  description: place.description,
                  phoneNumber: place.phoneNumber,
                  rating: place.rating,
                  hotelRating: place.hotelRating,
                  placeId: int.parse(place.id),
                ),
              ),
            );
          },
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Stack(
                      children: [_buildPlaceImage(), _buildImageGradient()],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          place.name,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber[600], size: 18),
                            const SizedBox(width: 4),
                            Text(
                              place.rating.toString(),
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Icon(ionicons['location_outline'], color: Colors.grey[600], size: 16),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                place.location,
                                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey[600]),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.white,
                    size: 24,
                  ),
                  onPressed: onLikePressed,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceImage() {
    return Image.network(
      place.image,
      width: double.infinity,
      height: 160,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => Container(
        height: 160,
        color: Colors.grey[200],
        child: Center(child: Icon(Icons.photo, color: Colors.grey[400], size: 40)),
      ),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Container(
          height: 160,
          color: Colors.grey[200],
          child: Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildImageGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black.withOpacity(0.3)],
            stops: const [0.6, 1],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/models/reccommended_places_model.dart';
import 'package:frontend/pages/tourist_details_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SavedPage extends StatefulWidget {
  const SavedPage({Key? key}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  late Future<List<ReccommendedPlacesModel>> _likedPlacesFuture;
  final Color _primaryColor = const Color(0xFF00A896);
  final Color _backgroundColor = Colors.white;

  @override
  void initState() {
    super.initState();
    _likedPlacesFuture = _fetchLikedPlaces();
  }

  Future<List<ReccommendedPlacesModel>> _fetchLikedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    final likedIds = prefs.getStringList('likedPlaces') ?? [];
    final token = prefs.getString('access_token');

    if (token == null) {
      throw Exception('Access token not found.');
    }

    if (likedIds.isEmpty) return [];

    try {
      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/recommended_places/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept-Charset': 'utf-8',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(utf8.decode(response.bodyBytes));
        return data
            .map((item) => ReccommendedPlacesModel.fromJson(item))
            .where((place) => likedIds.contains(place.id.toString()))
            .toList();
      } else {
        throw Exception('Failed to load places: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to fetch liked places: $e');
    }
  }

  Future<void> _removeLikedPlace(String placeId) async {
    final prefs = await SharedPreferences.getInstance();
    final likedIds = prefs.getStringList('likedPlaces') ?? [];
    likedIds.remove(placeId);
    await prefs.setStringList('likedPlaces', likedIds);
    setState(() {
      _likedPlacesFuture = _fetchLikedPlaces();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Removed from saved places',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: _primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: Text(
          'Хадгалсан газрууд',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: _backgroundColor,
        foregroundColor: Colors.black87,
      ),
      body: FutureBuilder<List<ReccommendedPlacesModel>>(
        future: _likedPlacesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
              ),
            );
          } else if (snapshot.hasError) {
            return _buildErrorWidget(snapshot.error.toString());
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return _buildLikedPlacesGrid(snapshot.data!);
          } else {
            return _buildEmptyState();
          }
        },
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
            const SizedBox(height: 16),
            Text('Алдаа гарлаа',
                style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(error,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _likedPlacesFuture = _fetchLikedPlaces();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: _primaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Дахин оролдох', style: GoogleFonts.poppins()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 60, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text('Хадгалсан газрууд байхгүй',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.grey[600])),
          const SizedBox(height: 8),
          Text('"Like" дарж дуртай газраа хадгалаарай',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildLikedPlacesGrid(List<ReccommendedPlacesModel> places) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: places.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemBuilder: (context, index) {
        final place = places[index];
        return GestureDetector(
          onTap: () => _navigateToDetails(context, place),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        place.image,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 120,
                          color: Colors.grey[200],
                          child: Icon(Icons.image, color: Colors.grey[400], size: 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(place.name,
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_outlined, size: 14, color: Colors.grey[600]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(place.location,
                                    style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, size: 16, color: Colors.amber),
                              const SizedBox(width: 4),
                              Text(place.rating.toString(),
                                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => _removeLikedPlace(place.id),
                  child: Icon(Icons.favorite, color: Colors.red, size: 24),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _navigateToDetails(BuildContext context, ReccommendedPlacesModel place) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TouristDetailsPage(
          image: place.image,
          images: place.images,
          name: place.name,
          location: place.location,
          description: place.description,
          phoneNumber: place.phoneNumber,
          hotelRating: place.hotelRating,
          rating: place.rating,
          placeId: int.parse(place.id),
        ),
      ),
    );
  }
}

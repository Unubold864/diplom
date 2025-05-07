import 'package:flutter/material.dart';
import 'package:frontend/pages/p%5BlaceMapPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/pages/hotel.dart';
import 'package:frontend/pages/parking.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TouristDetailsPage extends StatefulWidget {
  const TouristDetailsPage({
    super.key,
    required this.image,
    required this.images,
    required this.name,
    required this.location,
    required this.description,
    required this.phoneNumber,
    required this.rating,
    required this.hotelRating,
    required this.placeId, // Added to fetch related restaurants
  });

  final String image;
  final List<String> images;
  final String name;
  final String location;
  final String description;
  final String phoneNumber;
  final double rating;
  final String hotelRating;
  final int placeId;

  @override
  State<TouristDetailsPage> createState() => _TouristDetailsPageState();
}

class _TouristDetailsPageState extends State<TouristDetailsPage> {
  final Color primaryColor = const Color(0xFF00A896);
  final Color backgroundColor = Colors.white;
  final Color textColor = Colors.black87;
  final Color secondaryTextColor = Colors.grey[600]!;
  bool _isBooking = false;
  List<Map<String, dynamic>> _restaurants = [];
  bool _isLoadingRestaurants = false;
  String? _restaurantError;

  @override
  void initState() {
    super.initState();
    _fetchRestaurants();
  }

  Future<void> _fetchRestaurants() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    setState(() {
      _isLoadingRestaurants = true;
      _restaurantError = null;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/api/restaurants/?place_id=${widget.placeId}',
        ),
        headers: {
          'Accept': 'application/json; charset=utf-8',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes)) as List;
        print('Restaurants data: $data'); // Debug print

        setState(() {
          _restaurants =
              data.map((item) {
                // Debug print for image URL
                print('Restaurant ${item['name']} image: ${item['image_url']}');

                return {
                  'name': item['name'],
                  'rating': item['rating']?.toDouble() ?? 0.0,
                  'cuisine': item['cuisine'],
                  'image':
                      item['image_url'] ?? 'https://via.placeholder.com/150',
                  'description':
                      item['description'] ?? 'No description available',
                  'openHours': item['opening_hours'] ?? 'Not specified',
                  'phone': item['phone'] ?? 'No phone number',
                };
              }).toList();
        });
      } else {
        setState(() {
          _restaurantError =
              'Failed to load restaurants: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _restaurantError = 'Network error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoadingRestaurants = false;
      });
    }
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.5,
              maxScale: 3.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.black54,
                      child: Center(
                        child: CircularProgressIndicator(
                          value:
                              loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                        ),
                      ),
                    );
                  },
                  errorBuilder:
                      (context, error, stackTrace) => Container(
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                ),
              ),
            ),
          ),
    );
  }

  Future<void> _makePhoneCall() async {
    final Uri launchUri = Uri(scheme: 'tel', path: widget.phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Утасны дугаар буруу байна',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // TouristDetailsPage.dart - Зөвхөн газрын байршилтай холбоотой нэмэлт

  Future<void> _openMap() async {
  final response = await http.get(
    Uri.parse('http://127.0.0.1:8000/api/places/${widget.placeId}/'),
    headers: {'Accept': 'application/json'},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final latitude = data['latitude'];
    final longitude = data['longitude'];

    if (latitude != null && longitude != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MapScreen(
            latitude: latitude,
            longitude: longitude,
            placeName: widget.name,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Байршлын координат алга байна')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Газрын мэдээлэл олдсонгүй')),
    );
  }
}


  void _showRestaurants(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.85,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(25),
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.name}-н ресторанууд',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_isLoadingRestaurants)
                  const Center(child: CircularProgressIndicator())
                else if (_restaurantError != null)
                  Column(
                    children: [
                      Text(
                        _restaurantError!,
                        style: GoogleFonts.poppins(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _fetchRestaurants,
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                else if (_restaurants.isEmpty)
                  Text('No restaurants available', style: GoogleFonts.poppins())
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _restaurants.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final restaurant = _restaurants[index];
                      return GestureDetector(
                        onTap:
                            () => _showRestaurantDetails(context, restaurant),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.horizontal(
                                  left: Radius.circular(12),
                                ),
                                child: Image.network(
                                  restaurant['image'] ??
                                      'https://via.placeholder.com/150',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                  headers: const {
                                    'Accept': 'image/*',
                                  }, // Important for some servers
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value:
                                            loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                      ),
                                    );
                                  },
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        width: 100,
                                        height: 100,
                                        color: Colors.grey[200],
                                        child: const Icon(
                                          Icons.restaurant,
                                          size: 30,
                                        ),
                                      ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant['name'],
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        restaurant['cuisine'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            restaurant['rating'].toString(),
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const Spacer(),
                                          const Icon(
                                            Icons.access_time,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            restaurant['openHours'],
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRestaurantDetails(
    BuildContext context,
    Map<String, dynamic> restaurant,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.9,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      restaurant['name'],
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.grey),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    restaurant['image'],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          height: 200,
                          color: Colors.grey[200],
                          child: const Icon(Icons.restaurant, size: 50),
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      restaurant['rating'].toString(),
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.access_time, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      restaurant['openHours'],
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  restaurant['description'],
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final Uri launchUri = Uri(
                        scheme: 'tel',
                        path: restaurant['phone'],
                      );
                      launchUrl(launchUri);
                    },
                    icon: const Icon(Icons.call),
                    label: const Text('Залгах'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.image,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            primaryColor,
                          ),
                        ),
                      );
                    },
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                  DecoratedBox(
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
                ],
              ),
            ),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.name,
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.rating.toStringAsFixed(1),
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(Icons.location_on, color: primaryColor, size: 18),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          widget.location,
                          style: GoogleFonts.poppins(
                            color: secondaryTextColor,
                            fontSize: 15,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  Divider(color: Colors.grey[300], height: 1),
                  const SizedBox(height: 24),

                  Text(
                    "Тайлбар",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.description,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: secondaryTextColor,
                      height: 1.6,
                    ),
                  ),

                  const SizedBox(height: 24),
                  Divider(color: Colors.grey[300], height: 1),
                  const SizedBox(height: 24),

                  Text(
                    "Үйлчилгээ",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 4,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      _buildFeatureItem(Icons.hotel, "Зочид буудал"),
                      _buildFeatureItem(Icons.restaurant, "Ресторан"),
                      _buildFeatureItem(Icons.local_parking, "Зогсоол"),
                      // _buildFeatureItem(Icons.fitness_center, "Фитнес"),
                      // _buildFeatureItem(Icons.spa, "Спа"),
                      // _buildFeatureItem(Icons.air, "Агааржуулалт"),
                      // _buildFeatureItem(Icons.breakfast_dining, "Өглөөний цай"),
                    ],
                  ),

                  if (widget.images.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    Divider(color: Colors.grey[300], height: 1),
                    const SizedBox(height: 24),
                    Text(
                      "Зураг",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: widget.images.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder:
                            (_, index) => GestureDetector(
                              onTap:
                                  () => _showImageDialog(
                                    context,
                                    widget.images[index],
                                  ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Image.network(
                                    widget.images[index],
                                    fit: BoxFit.cover,
                                    loadingBuilder: (
                                      context,
                                      child,
                                      loadingProgress,
                                    ) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                primaryColor,
                                              ),
                                        ),
                                      );
                                    },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.broken_image,
                                                size: 30,
                                                color: Colors.grey,
                                              ),
                                            ),
                                  ),
                                ),
                              ),
                            ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),
                  Divider(color: Colors.grey[300], height: 1),
                  const SizedBox(height: 24),

                  Text(
                    "Холбогдох",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          child: Icon(Icons.person, size: 30),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Өнөболд",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                widget.phoneNumber,
                                style: GoogleFonts.poppins(
                                  color: secondaryTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.message, color: primaryColor),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.call, color: primaryColor),
                          onPressed: _makePhoneCall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Газрын байршил",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: 150,
                child: ElevatedButton(
                  onPressed: _isBooking ? null : _openMap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:
                      _isBooking
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : Text(
                            "Очих замыг харах",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "Ресторан") {
          _showRestaurants(context);
        } else if (label == "Зочид буудал") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HotelPage(placeId: widget.placeId),
            ),
          );
        } else if (label == "Зогсоол") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ParkingPage(placeId: widget.placeId),
            ),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: primaryColor, size: 20),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.poppins(fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

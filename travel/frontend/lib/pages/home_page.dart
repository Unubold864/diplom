import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // import хийсэн байна уу шалгаарай
import 'package:flutter/material.dart';
import 'package:frontend/pages/explore_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/saved_page.dart';
import 'package:frontend/widgets/nerby_places.dart';
import 'package:frontend/widgets/reccommended_places.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final Color persianGreen = const Color(0xFF00A896);

  final List<Widget> _pages = [
    const HomeContent(),
    const ExplorePage(),
    const SavedPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildFloatingNavigationBar(),
    );
  }

  Widget _buildFloatingNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 5),
            spreadRadius: 1,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFloatingNavItem(Icons.home_rounded, "Нүүр", 0),
            _buildFloatingNavItem(Icons.explore_rounded, "Үнэлгээ", 1),
            _buildFloatingNavItem(Icons.bookmark_rounded, "Хадгалсан", 2),
            _buildFloatingNavItem(Icons.person_rounded, "Профайл", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingNavItem(IconData icon, String label, int index) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 18 : 16,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? persianGreen.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? persianGreen : Colors.grey.shade400,
              size: 22,
            ),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: persianGreen,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = true;
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _allPlaces = [];
  String? _errorMessage;
  final Color persianGreen = const Color(0xFF00A896);

  void _performSearch(String query) {
    final searchLower = query.toLowerCase();
    setState(() {
      _isSearching = query.isNotEmpty;
      _searchResults = _allPlaces.where((place) {
        final name = (place['name'] ?? '').toString().toLowerCase();
        final type = (place['type'] ?? '').toString().toLowerCase();
        final desc = (place['description'] ?? '').toString().toLowerCase();
        return name.contains(searchLower) ||
            type.contains(searchLower) ||
            desc.contains(searchLower);
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadAllPlaces();
    _searchController.addListener(() {
      if (_searchController.text.isEmpty) {
        _performSearch('');
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllPlaces() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");

      if (token == null) {
        setState(() {
          _errorMessage = 'Нэвтрээгүй байна. Token олдсонгүй.';
          _isLoading = false;
        });
        return;
      }

      List<Map<String, dynamic>> combined = [];

      // Recommended places
      final res1 = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/recommended_places/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res1.statusCode == 200) {
        final List<dynamic> data1 = json.decode(utf8.decode(res1.bodyBytes));
        combined.addAll(data1.map((place) => {
              'id': place['id'],
              'name': place['name'] ?? '',
              'type': place['type'] ?? '',
              'description': place['description'] ?? '',
              'distance': '${place['distance_km'] ?? '---'} км',
              'rating': (place['rating'] ?? 0).toDouble(),
            }));
      }

      // Nearby places
      final res2 = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/nearby_places/'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );
      if (res2.statusCode == 200) {
        final List<dynamic> data2 = json.decode(utf8.decode(res2.bodyBytes));
        combined.addAll(data2.map((place) => {
              'id': place['id'],
              'name': place['name'] ?? '',
              'type': place['type'] ?? '',
              'description': place['description'] ?? '',
              'distance': '${place['distance_km'] ?? '---'} км',
              'rating': (place['rating'] ?? 0).toDouble(),
            }));
      }

      setState(() {
        _allPlaces = combined;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Сүлжээний алдаа: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildImprovedAppBar(
        context,
        _searchController,
        _performSearch,
        persianGreen,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: persianGreen))
          : _errorMessage != null
              ? Center(
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                )
              : _buildContent(),
    );
  }

  PreferredSizeWidget buildImprovedAppBar(
    BuildContext context,
    TextEditingController searchController,
    Function(String) performSearch,
    Color primaryColor,
  ) {
    return AppBar(
      backgroundColor: primaryColor,
      toolbarHeight: 100,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Сайн байна уу', style: TextStyle(color: Colors.white)),
          Text('Монголын үзэсгэлэнт газрууд',
              style: TextStyle(color: Colors.white70)),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Container(
            height: 55,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: TextField(
              controller: searchController,
              onChanged: performSearch,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: primaryColor),
                hintText: 'Үзмэр хайх...',
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return _isSearching ? _buildSearchResults() : _buildDefaultContent();
  }

  Widget _buildDefaultContent() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('Санал болгох газрууд',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const ReccommendedPlaces(),
        const SizedBox(height: 32),
        Text('Ойролцоох газрууд',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const NerbyPlaces(),
      ],
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final place = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            title: Text(place['name']),
            subtitle: Text('${place['type']} - ${place['distance']}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, color: Colors.amber, size: 16),
                Text('${place['rating']}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/saved_page.dart';
import 'package:frontend/widgets/location_card.dart';
import 'package:frontend/widgets/nerby_places.dart';
import 'package:frontend/widgets/reccommended_places.dart';
import 'package:google_fonts/google_fonts.dart';

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
    const Scaffold(body: Center(child: Text('Notifications Page'))),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildFloatingNavigationBar(),
    );
  }

  Widget _buildFloatingNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildFloatingNavItem(Icons.home_outlined, "Нүүр", 0),
            _buildFloatingNavItem(Icons.notifications_outlined, "Мэдэгдэл", 1),
            _buildFloatingNavItem(Icons.bookmark_outlined, "Хадгалсан", 2),
            _buildFloatingNavItem(Icons.person_outlined, "Профайл", 3),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? persianGreen.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? persianGreen : Colors.grey,
              size: 20,
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: persianGreen,
                ),
              ),
            ],
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
      // Replace with your actual data loading logic
      await Future.delayed(const Duration(seconds: 1)); // Simulate loading

      // Mock data - replace with your real data
      final recommended = [
        {
          'id': 1,
          'name': 'Төв цэнгэлдэх хүрээлэн',
          'type': 'Цэнгэлдэх хүрээлэн',
          'description': 'Улаанбаатар хотын төвд байрлах цэнгэлдэх хүрээлэн',
          'distance': '1.5 км',
          'rating': 4.5,
        },
        {
          'id': 2,
          'name': 'Гандан хийд',
          'type': 'Шашны сүм',
          'description': 'Монголын томоохон буддын сүм',
          'distance': '3.2 км',
          'rating': 4.7,
        },
      ];

      final nearby = [
        {
          'id': 3,
          'name': 'Сүхбаатарын талбай',
          'type': 'Түүхэн дурсгал',
          'description': 'Улаанбаатар хотын төв талбай',
          'distance': '0.5 км',
          'rating': 4.3,
        },
        {
          'id': 4,
          'name': 'Үндэсний музей',
          'type': 'Музей',
          'description': 'Монголын түүх, соёлын өв',
          'distance': '2.1 км',
          'rating': 4.6,
        },
      ];

      setState(() {
        _allPlaces = [...recommended, ...nearby];
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Алдаа гарлаа: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _performSearch(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;
      _searchResults =
          _isSearching
              ? _allPlaces.where((place) {
                final searchLower = query.toLowerCase();
                return place['name'].toLowerCase().contains(searchLower) ||
                    place['type'].toLowerCase().contains(searchLower) ||
                    (place['description']?.toLowerCase()?.contains(
                          searchLower,
                        ) ??
                        false);
              }).toList()
              : [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1FBCB8),
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Logo or app name can go here
            Text(
              'Explore Mongolia',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, size: 24),
            onPressed: () {},
            color: Colors.white,
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      const Icon(Icons.search, color: Colors.grey, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: "Хайх...",
                            border: InputBorder.none,
                            hintStyle: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          style: GoogleFonts.poppins(fontSize: 16),
                          onChanged: _performSearch,
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _performSearch('');
                          },
                        ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage != null
              ? Center(child: Text(_errorMessage!))
              : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LocationCard(),
                    const SizedBox(height: 25),

                    if (_isSearching) ...[
                      _buildSearchResults(),
                    ] else ...[
                      _buildSectionHeader(
                        context,
                        title: "Санал болгох газрууд",
                        onViewAll: () {},
                      ),
                      const SizedBox(height: 20),
                      const ReccommendedPlaces(),
                      const SizedBox(height: 30),
                      _buildSectionHeader(
                        context,
                        title: "Ойролцоох газрууд",
                        onViewAll: () {},
                      ),
                      const SizedBox(height: 20),
                      const NerbyPlaces(),
                    ],
                  ],
                ),
              ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Хайлтын үр дүн (${_searchResults.length})',
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        if (_searchResults.isEmpty)
          Center(
            child: Text(
              'Хайлтанд тохирох үр дүн олдсонгүй',
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          )
        else
          ..._searchResults.map(
            (place) => Card(
              margin: const EdgeInsets.only(bottom: 16),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: const Icon(Icons.place, color: Color(0xFF00A896)),
                title: Text(
                  place['name'],
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(place['type']),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        Text(' ${place['rating']}'),
                        const SizedBox(width: 16),
                        const Icon(Icons.directions_walk, size: 16),
                        Text(' ${place['distance']}'),
                      ],
                    ),
                  ],
                ),
                onTap: () {
                  // Handle place selection
                },
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onViewAll,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            "Бүгдийг харах",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: persianGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

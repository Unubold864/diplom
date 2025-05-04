import 'package:flutter/material.dart';
import 'package:frontend/pages/explore_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/saved_page.dart';
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
      backgroundColor: const Color(0xFFF5F5F5),
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildFloatingNavigationBar(),
    );
  }

  Widget _buildFloatingNavigationBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFloatingNavItem(Icons.home, "Нүүр", 0),
            _buildFloatingNavItem(Icons.explore, "Үнэлгээ", 1),
            _buildFloatingNavItem(Icons.bookmark, "Хадгалсан", 2),
            _buildFloatingNavItem(Icons.person, "Профайл", 3),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected ? persianGreen.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? persianGreen : Colors.grey),
            if (isSelected)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
      await Future.delayed(const Duration(seconds: 1));
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: persianGreen,
        title: Text(
          'Сайн байна уу',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: _performSearch,
                decoration: InputDecoration(
                  hintText: 'Хайх...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon:
                      _searchController.text.isNotEmpty
                          ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                          : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
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
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    if (_isSearching)
                      _buildSearchResults()
                    else ...[
                      _buildSectionHeader('Санал болгох газрууд'),
                      const SizedBox(height: 10),
                      const ReccommendedPlaces(),
                      const SizedBox(height: 20),
                      _buildSectionHeader('Ойролцоох газрууд'),
                      const SizedBox(height: 10),
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
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_searchResults.isEmpty)
          Center(
            child: Text(
              'Үр дүн олдсонгүй',
              style: TextStyle(color: Colors.grey),
            ),
          )
        else
          Column(
            children:
                _searchResults
                    .map(
                      (place) => Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.place,
                            color: Color(0xFF00A896),
                          ),
                          title: Text(
                            place['name'],
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(place['type']),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  Text(' ${place['rating']}'),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.directions_walk, size: 16),
                                  Text(' ${place['distance']}'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: Text('Бүгдийг харах', style: TextStyle(color: persianGreen)),
        ),
      ],
    );
  }
}

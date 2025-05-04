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
          vertical: 10
        ),
        decoration: BoxDecoration(
          color: isSelected ? persianGreen.withOpacity(0.12) : Colors.transparent,
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
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: persianGreen,
                strokeWidth: 3,
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 48,
                        color: Colors.red.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _errorMessage!,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.red.shade400,
                        ),
                      ),
                    ],
                  ),
                )
              : _buildContent(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: persianGreen,
      toolbarHeight: 70,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      title: Text(
        'Сайн байна уу',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {},
          ),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _performSearch,
              style: GoogleFonts.poppins(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Хайх...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: persianGreen,
                  size: 22,
                ),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear_rounded,
                              color: Colors.grey.shade400,
                              size: 20,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                          )
                        : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_isSearching)
            _buildSearchResults()
          else ...[
            _buildSectionHeader('Санал болгох газрууд'),
            const SizedBox(height: 16),
            const ReccommendedPlaces(),
            const SizedBox(height: 32),
            _buildSectionHeader('Ойролцоох газрууд'),
            const SizedBox(height: 16),
            const NerbyPlaces(),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Хайлтын үр дүн (${_searchResults.length})',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        if (_searchResults.isEmpty)
          Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 16),
                Text(
                  'Үр дүн олдсонгүй',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              final place = _searchResults[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: persianGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.place_rounded,
                      color: persianGreen,
                      size: 28,
                    ),
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      place['name'],
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place['type'],
                        style: GoogleFonts.poppins(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                Text(
                                  ' ${place['rating']}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.amber.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: persianGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.directions_walk_rounded,
                                  size: 16,
                                  color: persianGreen,
                                ),
                                Text(
                                  ' ${place['distance']}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                    color: persianGreen,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
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
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Бүгдийг харах',
            style: GoogleFonts.poppins(
              color: persianGreen,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/widgets/location_card.dart';
import 'package:frontend/widgets/nerby_places.dart';
import 'package:frontend/widgets/reccommended_places.dart';
import 'package:frontend/widgets/tourist_places.dart';
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
    const Scaffold(body: Center(child: Text('Saved Page'))),
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

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final Color persianGreen = const Color(0xFF00A896);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1FBCB8), // Teal color from the image
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Location",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Row(
                  children: [
                    const Text(
                      "New York, USA",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 16,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.white24,
              radius: 16,
              child: Icon(
                Icons.notifications_outlined,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        const Icon(Icons.search, color: Colors.grey),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search Hotel, Flights etc...",
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LocationCard(),
            const SizedBox(height: 25),
            //const TouristPlaces(),
            const SizedBox(height: 30),
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
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required VoidCallback onViewAll,
  }) {
    final Color persianGreen = const Color(0xFF00A896);
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

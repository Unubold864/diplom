import 'package:flutter/material.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/widgets/custom_icon_button.dart';
import 'package:frontend/widgets/location_card.dart';
import 'package:frontend/widgets/nerby_places.dart';
import 'package:frontend/widgets/reccommended_places.dart';
import 'package:frontend/widgets/tourist_places.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_named/ionicons_named.dart';

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
          color: isSelected ? persianGreen.withOpacity(0.1) : Colors.transparent,
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
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        title: Text(
          "Diplom",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          CustomIconButton(
            icon: Icon(
              ionicons['search_outline'],
              color: persianGreen,
              size: 24,
            ),
            onTap: () {},
          ),
          CustomIconButton(
            icon: Icon(
              ionicons['notifications_outline'],
              color: persianGreen,
              size: 24,
            ),
            showBadge: true,
            onTap: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LocationCard(),
            const SizedBox(height: 25),
            const TouristPlaces(),
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
            "View All",
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
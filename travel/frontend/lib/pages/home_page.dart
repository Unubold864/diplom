import 'package:flutter/material.dart';
import 'package:frontend/pages/profile_page.dart'; // Import the ProfilePage
import 'package:frontend/widgets/custom_icon_button.dart';
import 'package:frontend/widgets/location_card.dart';
import 'package:frontend/widgets/nerby_places.dart';
import 'package:frontend/widgets/reccommended_places.dart';
import 'package:frontend/widgets/tourist_places.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_named/ionicons_named.dart';

class HomePage extends StatefulWidget { // Changed to StatefulWidget
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Track the selected bottom navigation item

  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);

  // Define the pages for navigation
  final List<Widget> _pages = [
    const HomeContent(), // The existing home content
    const Scaffold(body: Center(child: Text('Saved Page'))),
    const Scaffold(body: Center(child: Text('Favorites Page'))),
    const ProfilePage(), // Added ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1), // Subtle shadow
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex, // Add this line
          onTap: _onItemTapped, // Add this line
          elevation: 0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: persianGreen, // Persian Green for selected items
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          items: [
            _buildNavItem(context, Icons.home_outlined, "Home", _selectedIndex == 0),
            _buildNavItem(context, Icons.bookmark_border, "Saved", _selectedIndex == 1),
            _buildNavItem(context, Icons.favorite_border, "Favorites", _selectedIndex == 2),
            _buildNavItem(context, Icons.person_outline, "Profile", _selectedIndex == 3),
          ],
        ),
      ),
    );
  }

  // Helper method to build a navigation item
  BottomNavigationBarItem _buildNavItem(
      BuildContext context, IconData icon, String label, bool isSelected) {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: label,
    );
  }
}

// Extract the original home content to a separate widget
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
              title: "Recommended Places",
              onViewAll: () {},
            ),
            const SizedBox(height: 20),
            const ReccommendedPlaces(),
            const SizedBox(height: 30),
            _buildSectionHeader(
              context,
              title: "Nearby",
              onViewAll: () {},
            ),
            const SizedBox(height: 20),
            const NerbyPlaces(),
          ],
        ),
      ),
    );
  }

  // Keep the existing helper methods from the original HomePage
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
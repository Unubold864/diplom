import 'package:flutter/material.dart';
import 'package:frontend/widgets/custom_icon_button.dart';
import 'package:frontend/widgets/location_card.dart';
import 'package:frontend/widgets/nerby_places.dart';
import 'package:frontend/widgets/reccommended_places.dart';
import 'package:frontend/widgets/tourist_places.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_named/ionicons_named.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 4, // Add elevation for shadow
        backgroundColor: Colors.white, // Solid white background
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
        ),
        
        actions: [
          CustomIconButton(
            icon: Icon(
              ionicons['search_outline'],
              color: persianGreen, // Use Persian Green for icons
              size: 22,
            ),
            onTap: () {},
          ),
          CustomIconButton(
            icon: Icon(
              ionicons['notifications_outline'],
              color: persianGreen, // Use Persian Green for icons
              size: 22,
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
              title: "Recommendation",
              onViewAll: () {},
            ),
            const SizedBox(height: 20),
            const ReccommendedPlaces(),
            const SizedBox(height: 30),
            _buildSectionHeader(
              context,
              title: "Nearby From You",
              onViewAll: () {},
            ),
            const SizedBox(height: 20),
            const NerbyPlaces(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSectionHeader(BuildContext context, {
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
            "View All",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: persianGreen, // Use Persian Green for "View All"
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
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
          elevation: 0,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          selectedItemColor: persianGreen, // Use Persian Green for selected items
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          unselectedLabelStyle: GoogleFonts.poppins(fontSize: 12),
          items: [
            _buildNavItem(context, ionicons['home']!, "Home", true),
            _buildNavItem(context, ionicons['bookmark']!, "Saved", false),
            _buildNavItem(context, ionicons['heart']!, "Favorites", false),
            _buildNavItem(context, ionicons['person']!, "Profile", false),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
    BuildContext context,
    IconData icon,
    String label,
    bool isSelected,
  ) {
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? persianGreen.withOpacity(0.15) // Use Persian Green for selected state
              : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(
                  color: persianGreen.withOpacity(0.3), // Persian Green border
                  width: 1,
                )
              : null,
        ),
        child: Icon(
          icon,
          size: 22,
          color: isSelected ? persianGreen : Colors.grey[400], // Persian Green for selected icon
        ),
      ),
      label: label,
    );
  }
}
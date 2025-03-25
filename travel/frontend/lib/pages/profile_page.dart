import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_named/ionicons_named.dart';
import 'package:frontend/widgets/custom_icon_button.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // Define Persian Green as the primary color (matching HomePage)
  final Color persianGreen = const Color(0xFF00A896);

  @override
  Widget build(BuildContext context) {
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
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          CustomIconButton(
            icon: Icon(
              ionicons['settings_outline'],
              color: persianGreen,
              size: 24,
            ),
            onTap: () {
              // TODO: Implement settings navigation
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 30),
            _buildProfileSection(),
            const SizedBox(height: 30),
            _buildAccountSection(),
            const SizedBox(height: 30),
            _buildPreferencesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: persianGreen.withOpacity(0.1),
            child: Icon(
              ionicons['person'],
              size: 70,
              color: persianGreen,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            "John Doe",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            "john.doe@example.com",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return _buildSection(
      title: "Profile",
      items: [
        _buildProfileItem(
          icon: ionicons['person_outline'] ?? Icons.person_outline,
          title: "Edit Profile",
          onTap: () {},
        ),
        _buildProfileItem(
          icon: ionicons['shield_outline'] ?? Icons.shield_outlined,
          title: "Privacy",
          onTap: () {},
        ),
        _buildProfileItem(
          icon: ionicons['lock_closed_outline'] ?? Icons.lock_outline,
          title: "Security",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: "Account",
      items: [
        _buildProfileItem(
          icon: ionicons['card_outline'] ?? Icons.credit_card,
          title: "Payment Methods",
          onTap: () {},
        ),
        _buildProfileItem(
          icon: ionicons['bookmark_outline'] ?? Icons.bookmark_outline,
          title: "Bookings",
          onTap: () {},
        ),
        _buildProfileItem(
          icon: ionicons['heart_outline'] ?? Icons.favorite_outline,
          title: "My Favorites",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: "Preferences",
      items: [
        _buildProfileItem(
          icon: ionicons['language_outline'] ?? Icons.language,
          title: "Language",
          onTap: () {},
        ),
        _buildProfileItem(
          icon: ionicons['moon_outline'] ?? Icons.brightness_2_outlined,
          title: "Dark Mode",
          trailing: Switch(
            value: false,
            activeColor: persianGreen,
            onChanged: (bool value) {
              // TODO: Implement dark mode toggle
            },
          ),
        ),
        _buildProfileItem(
          icon: ionicons['notifications_outline'] ?? Icons.notifications_outlined,
          title: "Notifications",
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: persianGreen,
        size: 24,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
        ),
      ),
      trailing: trailing ?? Icon(
        ionicons['chevron_forward_outline'],
        color: Colors.grey[400],
      ),
      onTap: onTap,
    );
  }
}
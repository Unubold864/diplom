import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_named/ionicons_named.dart';
import 'package:frontend/widgets/custom_icon_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);

  // User profile data
  Map<String, dynamic> _userData = {
    'name': 'Loading...',
    'email': 'loading@example.com',
  };

  bool _isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final accessToken = prefs.getString('access_token');

      if (accessToken == null) {
        _showErrorDialog('No access token found. Please log in again');
        // Redirect to login page
        return;
      }

      print('Access Token: $accessToken');

      // Make API call to fetch user profile
      final response = await http.get(
        Uri.parse(
          'http://127.0.0.1:8000/api/profile/',
        ), // Replace with your actual backend URL
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() {
          _userData = json.decode(response.body);
        });
      } else {
        _showErrorDialog('Failed to load profile ${response.body}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      _showErrorDialog('Error connecting to server $e');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text('Error', style: GoogleFonts.poppins(color: Colors.red)),
            content: Text(message, style: GoogleFonts.poppins()),
            actions: <Widget>[
              TextButton(
                child: Text(
                  'Okay',
                  style: GoogleFonts.poppins(color: persianGreen),
                ),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
    );
  }

  Future<void> _logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear stored token
      await prefs.remove('access_token');
      await prefs.remove('refresh_token');

      // Navigate to login page and remove all previous routes
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      _showErrorDialog('Logout failed');
    }
  }

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
            const SizedBox(height: 30),
            _buildLogoutButton(),
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
            child: Icon(ionicons['person'], size: 70, color: persianGreen),
          ),
          const SizedBox(height: 15),
          Text(
            _userData['name'] ?? 'User',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            _userData['email'] ?? 'email@example.com',
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ElevatedButton(
      onPressed: _logout,
      style: ElevatedButton.styleFrom(
        backgroundColor: persianGreen,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        'Logout',
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildProfileSection() {
    return _buildSection(
      title: "Profile",
      items: [
        _buildProfileItem(
          icon: ionicons['person_outline'] ?? Icons.person,
          title: "Edit Profile",
          onTap: () {
            // TODO: Implement edit profile
          },
        ),
        _buildProfileItem(
          icon: ionicons['shield_outline'] ?? Icons.shield,
          title: "Privacy",
          onTap: () {
            // TODO: Implement privacy settings
          },
        ),
        _buildProfileItem(
          icon: ionicons['lock_closed_outline'] ?? Icons.lock,
          title: "Security",
          onTap: () {
            // TODO: Implement security settings
          },
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
          onTap: () {
            // TODO: Implement payment methods
          },
        ),
        _buildProfileItem(
          icon: ionicons['bookmark_outline'] ?? Icons.bookmark,
          title: "Bookings",
          onTap: () {
            // TODO: Implement bookings
          },
        ),
        _buildProfileItem(
          icon: ionicons['heart_outline'] ?? Icons.favorite_border,
          title: "My Favorites",
          onTap: () {
            // TODO: Implement favorites
          },
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
          onTap: () {
            // TODO: Implement language selection
          },
        ),
        _buildProfileItem(
          icon: ionicons['moon_outline'] ?? Icons.nightlight_round,
          title: "Dark Mode",
          trailing: Switch(
            value: _isDarkMode,
            activeColor: persianGreen,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
                // TODO: Implement dark mode toggle logic
              });
            },
          ),
        ),
        _buildProfileItem(
          icon: ionicons['notifications_outline'] ?? Icons.notifications,
          title: "Notifications",
          onTap: () {
            // TODO: Implement notifications settings
          },
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
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
      leading: Icon(icon, color: persianGreen, size: 24),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 16, color: Colors.black87),
      ),
      trailing:
          trailing ??
          Icon(ionicons['chevron_forward_outline'], color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons_named/ionicons_named.dart';
import 'package:frontend/widgets/custom_icon_button.dart';
import 'dart:convert';
import 'package:frontend/services/api_service.dart'; // Import the new API service

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Define Persian Green as the primary color
  final Color persianGreen = const Color(0xFF00A896);
  
  // Create an instance of our API service
  final ApiService _apiService = ApiService();

  // User profile data
  Map<String, dynamic> _userData = {
    'name': 'Ачаалж байна...',
    'email': 'loading@example.com',
  };

  bool _isDarkMode = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);
    
    try {
      // Use the API service to make a GET request
      final response = await _apiService.get('/profile/');

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        try {
          final data = json.decode(response.body);
          setState(() => _userData = data);
        } catch (e) {
          print('JSON задлах үед алдаа гарлаа: $e');
          _showErrorDialog('Профайл мэдээлэл задлах үед алдаа гарлаа');
        }
      } else {
        print('Серверийн хариу: ${response.body}');
        _showErrorDialog('Профайл ачаалахад алдаа гарлаа: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print('Профайл ачаалах үед алдаа гарлаа: $e');
      if (mounted) {
        _showErrorDialog('Серверт холбогдоход алдаа гарлаа: $e');
      }
    }
  }

  void _showErrorDialog(String message) {
    if (!mounted) return;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Алдаа', style: GoogleFonts.poppins(color: Colors.red)),
        content: Text(message, style: GoogleFonts.poppins()),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Ойлголоо',
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
      // Use API service to clear tokens
      await _apiService.clearTokens();
      
      // Navigate to login page
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      print('Гарах үед алдаа гарлаа: $e');
      if (mounted) {
        _showErrorDialog('Системээс гарах үед алдаа гарлаа');
      }
    }
  }

  // The rest of your UI code stays the same
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
          "Профайл",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        actions: [
          CustomIconButton(
            icon: Icon(
              ionicons['settings_outline'] ?? Icons.settings,
              color: persianGreen,
              size: 24,
            ),
            onTap: () {
              // TODO: Тохиргоо хуудас руу шилжих
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          color: persianGreen,
          onRefresh: _fetchUserProfile,
          child: _isLoading 
              ? _buildLoadingState()
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  // The rest of your widget building methods remain the same
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildProfileHeader() {
    return Center(
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: persianGreen.withOpacity(0.1),
            child: Icon(ionicons['person'] ?? Icons.person, size: 70, color: persianGreen),
          ),
          const SizedBox(height: 15),
          Text(
            _userData['name'] ?? 'Хэрэглэгч',
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
        'Гарах',
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
      title: "Профайл",
      items: [
        _buildProfileItem(
          icon: ionicons['person_outline'] ?? Icons.person_outline,
          title: "Профайл засах",
          onTap: () {
            // TODO: Профайл засах хуудас руу шилжих
          },
        ),
        _buildProfileItem(
          icon: ionicons['shield_outline'] ?? Icons.shield_outlined,
          title: "Нууцлал",
          onTap: () {
            // TODO: Нууцлалын тохиргоо хуудас руу шилжих
          },
        ),
        _buildProfileItem(
          icon: ionicons['lock_closed_outline'] ?? Icons.lock_outline,
          title: "Аюулгүй байдал",
          onTap: () {
            // TODO: Аюулгүй байдлын тохиргоо хуудас руу шилжих
          },
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _buildSection(
      title: "Бүртгэл",
      items: [
        _buildProfileItem(
          icon: ionicons['card_outline'] ?? Icons.credit_card,
          title: "Төлбөрийн хэрэгслүүд",
          onTap: () {
            // TODO: Төлбөрийн хэрэгслүүдийн хуудас руу шилжих
          },
        ),
        _buildProfileItem(
          icon: ionicons['bookmark_outline'] ?? Icons.bookmark_border,
          title: "Захиалгууд",
          onTap: () {
            // TODO: Захиалгуудын хуудас руу шилжих
          },
        ),
        _buildProfileItem(
          icon: ionicons['heart_outline'] ?? Icons.favorite_border,
          title: "Миний дуртай",
          onTap: () {
            // TODO: Таалагдсан зүйлсийн хуудас руу шилжих
          },
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return _buildSection(
      title: "Тохиргоо",
      items: [
        _buildProfileItem(
          icon: ionicons['language_outline'] ?? Icons.language,
          title: "Хэл",
          onTap: () {
            // TODO: Хэл сонгох хуудас руу шилжих
          },
        ),
        _buildProfileItem(
          icon: ionicons['moon_outline'] ?? Icons.dark_mode_outlined,
          title: "Харанхуй горим",
          trailing: Switch(
            value: _isDarkMode,
            activeColor: persianGreen,
            onChanged: (bool value) {
              setState(() {
                _isDarkMode = value;
                // TODO: Харанхуй горим тохируулах логик
              });
            },
          ),
        ),
        _buildProfileItem(
          icon: ionicons['notifications_outline'] ?? Icons.notifications_outlined,
          title: "Мэдэгдлүүд",
          onTap: () {
            // TODO: Мэдэгдлүүдийн тохиргоо хуудас руу шилжих
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
      trailing: trailing ??
          Icon(ionicons['chevron_forward_outline'] ?? Icons.chevron_right, color: Colors.grey[400]),
      onTap: onTap,
    );
  }
}
import 'dart:io';
import 'package:car_rental_project/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_rental_project/utils/session_manager.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String userEmail = '';
  String? profilePhotoPath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'Bunga';
      userEmail = prefs.getString('userEmail') ?? 'bunga@gmail.com';
      profilePhotoPath = prefs.getString('profile_photo');
    });
  }

  Future<void> _logout() async {
    await SessionManager.clearSession();
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1220) : Colors.grey[100],
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: [
            // HEADER 
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0F172A), const Color(0xFF071028)]
                      : [const Color(0xFF4B6EF6), const Color(0xFF93C5FD)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.1),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profilePhotoPath != null && File(profilePhotoPath!).existsSync()
                        ? FileImage(File(profilePhotoPath!)) as ImageProvider
                        : const AssetImage('assets/images/profile.png'),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          userEmail,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final updated = await Navigator.push<bool?>(
                        context,
                        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                      );
                      if (updated == true) {
                        _loadUserData();
                      }
                    },
                    icon: const Icon(Icons.edit, color: Colors.white),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            //  Dark Mode Switch
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: isDark ? const Color(0xFF1C2431) : Colors.white,
              elevation: 6,
              shadowColor: isDark ? Colors.black54 : Colors.grey.withOpacity(0.2),
              child: SwitchListTile(
                title: Text(
                  "Dark Mode",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                secondary: const Icon(Icons.dark_mode_outlined, color: Colors.purple),
                value: isDark,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
            ),

            const SizedBox(height: 16),

            //  Settings Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: isDark ? const Color(0xFF1C2431) : Colors.white,
              elevation: 6,
              shadowColor: isDark ? Colors.black54 : Colors.grey.withOpacity(0.2),
              child: ListTile(
                leading: const Icon(Icons.settings_outlined, color: Colors.purple),
                title: Text(
                  "Settings",
                  style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.grey.shade900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
            ),

            const SizedBox(height: 40),

            //  Logout Button
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  "Logout",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B6EF6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 6,
                  shadowColor: Colors.blueAccent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

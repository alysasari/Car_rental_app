
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental_project/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0B1220) : const Color(0xFFF7FBFF),
      body: SafeArea(
        child: Column(
          children: [
            //HEADER 
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF071028)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : const LinearGradient(
                        colors: [Color(0xFF4B6EF6), Color(0xFF93C5FD)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(36)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                children: [
                 
                  _settingTile(
                    context: context,
                    icon: Icons.policy_outlined,
                    title: 'Privacy Policy',
                    onTap: () => _showInfoDialog(
                      context,
                      title: 'Privacy Policy',
                      content:
                          'We respect your privacy. Your data will only be used to enhance your car rental experience and will never be shared with third parties.',
                    ),
                  ),
                  const SizedBox(height: 12),

               
                  _settingTile(
                    context: context,
                    icon: Icons.article_outlined,
                    title: 'Terms & Conditions',
                    onTap: () => _showInfoDialog(
                      context,
                      title: 'Terms & Conditions',
                      content:
                          'By using Car Rent & Go, you agree to follow all rules regarding booking, payments, cancellations, and user conduct.',
                    ),
                  ),
                  const SizedBox(height: 12),

                  // === About App ===
                  _settingTile(
                    context: context,
                    icon: Icons.info_outline_rounded,
                    title: 'About App',
                    onTap: () => _showInfoDialog(
                      context,
                      title: 'About Car Rent & Go',
                      content:
                          'Car Rent & Go is a modern car rental app designed for a smooth and simple experience. '
                          'You can explore vehicles, filter based on your preferences, and book instantly all in one place.',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      tileColor: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
      leading: CircleAvatar(
        backgroundColor: const Color(0xFF4B6EF6).withOpacity(0.1),
        child: Icon(icon, color: const Color(0xFF4B6EF6)),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      onTap: onTap,
    );
  }

  void _showInfoDialog(BuildContext context,
      {required String title, required String content}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Close",
              style: TextStyle(color: Color(0xFF4B6EF6)),
            ),
          ),
        ],
      ),
    );
  }
}

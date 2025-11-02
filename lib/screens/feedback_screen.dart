// lib/screens/feedback_screen.dart
import 'package:car_rental_project/database/database_helper.dart';
import 'package:car_rental_project/screens/feedback_result_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme_provider.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackCtrl = TextEditingController();
  double _rating = 4.0;

  late AnimationController _controller;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideIn = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _feedbackCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1220) : Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            // ===== HEADER (GRADIENT SERAGAM DENGAN HOMESCREEN) =====
            Container(
              height: 160,
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF0F172A), const Color(0xFF071028)]
                      : [const Color(0xFF4B6EF6), const Color(0xFF93C5FD)],
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
              child: const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "Pesan & Kesan",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
              ),
            ),

            // ===== BODY FORM =====
            FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideIn,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 200, 16, 30),
                  children: [
                    Card(
                      elevation: 10,
                      color:
                          isDark ? const Color(0xFF1C2431) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor: isDark
                          ? Colors.black54
                          : Colors.grey.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 26),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 38,
                                backgroundColor: isDark
                                    ? Colors.white.withOpacity(0.08)
                                    : Colors.blue.shade50.withOpacity(0.4),
                                child: const Icon(
                                  Icons.feedback_outlined,
                                  size: 38,
                                  color: Color(0xFF4B6EF6),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Text(
                                "Bagikan Pendapatmu",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.grey.shade900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Kami ingin tahu kesan dan saran kamu ✨",
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 26),

                              // ⭐ Rating
                              Text(
                                'Seberapa puas kamu?',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    onPressed: () => setState(
                                        () => _rating = index + 1.0),
                                    icon: Icon(
                                      index < _rating
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: Colors.amber,
                                      size: 36,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 25),

                              // 💬 Feedback Field
                              TextFormField(
                                controller: _feedbackCtrl,
                                maxLines: 5,
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : Colors.grey.shade900,
                                ),
                                decoration: InputDecoration(
                                  labelText:
                                      'Tulis saran atau kesanmu',
                                  labelStyle: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : Colors.grey.shade700,
                                  ),
                                  alignLabelWithHint: true,
                                  prefixIcon: const Icon(
                                    Icons.edit_note_outlined,
                                    color: Colors.grey,
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? Colors.white.withOpacity(0.05)
                                      : Colors.blue.shade50.withOpacity(0.4),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    borderSide: BorderSide(
                                      color: isDark
                                          ? Colors.white24
                                          : Colors.blue.shade200,
                                    ),
                                  ),
                                ),
                                validator: (v) =>
                                    v == null || v.isEmpty
                                        ? 'Tuliskan pendapatmu minimal sedikit ya!'
                                        : null,
                              ),
                              const SizedBox(height: 35),

                              // 🚀 Button Kirim
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  onPressed: () async {
                                    if (_formKey.currentState!
                                        .validate()) {
                                      await DatabaseHelper.instance
                                          .insertFeedback({
                                        'user_id': 1,
                                        'message': _feedbackCtrl.text,
                                        'created_at': DateTime.now()
                                            .toIso8601String(),
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              '🎉 Terima kasih! Feedback kamu terkirim.'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      _feedbackCtrl.clear();
                                      setState(() => _rating = 4.0);

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const FeedbackResultScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  icon: const Icon(Icons.send_rounded,
                                      color: Colors.white),
                                  label: const Text(
                                    'Kirim Feedback',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color(0xFF4B6EF6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                    shadowColor: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ).animate().fadeIn(duration: 600.ms).moveY(begin: 40, end: 0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

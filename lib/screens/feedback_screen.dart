import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../database/database_helper.dart';
import '../utils/session_manager.dart';
import 'feedback_result_screen.dart';

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
        child: CustomScrollView(
          slivers: [
           
            SliverAppBar(
              expandedHeight: 110,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF4A90E2),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(22),
                      bottomRight: Radius.circular(22),
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        offset: Offset(0, 4),
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 38, 20, 18),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Feedback",
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 6),
                     
                    
                    ],
                  ),
                ),
              ),
            ),

            
            SliverToBoxAdapter(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideIn,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                    child: Card(
                      elevation: 10,
                      color: isDark ? const Color(0xFF1C2431) : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      shadowColor:
                          isDark ? Colors.black54 : Colors.grey.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 26),
                        child: Form(
                          key: _formKey,
                          child: Column(
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
                              const SizedBox(height: 6),
                              Text(
                                "Kami ingin tahu kesan dan saran kamu ✨",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 28),

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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (index) {
                                  return IconButton(
                                    onPressed: () =>
                                        setState(() => _rating = index + 1.0),
                                    icon: Icon(
                                      index < _rating
                                          ? Icons.star_rounded
                                          : Icons.star_border_rounded,
                                      color: Colors.amber,
                                      size: 34,
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 25),

                              // 📝 Input
                              TextFormField(
                                controller: _feedbackCtrl,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'Tulis saran atau kesanmu',
                                  alignLabelWithHint: true,
                                  prefixIcon: const Icon(
                                      Icons.edit_note_rounded, color: Colors.grey),
                                  filled: true,
                                  fillColor: isDark
                                      ? Colors.white.withOpacity(0.07)
                                      : Colors.blue.shade50.withOpacity(0.4),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                validator: (v) => v == null || v.isEmpty
                                    ? 'Tuliskan sedikit pendapatmu!'
                                    : null,
                              ),
                              const SizedBox(height: 35),

                              //  Button
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton.icon(
                                  icon: const Icon(Icons.send_rounded),
                                  label: const Text("Kirim Feedback",
                                      style: TextStyle(fontSize: 16)),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      final user =
                                          await SessionManager.getUserData();
                                      final userId =
                                          int.tryParse(user['id'] ?? '') ?? 1;

                                      await DatabaseHelper.instance.insertFeedback({
                                        'user_id': userId,
                                        'message': _feedbackCtrl.text,
                                        'created_at': DateTime.now().toIso8601String(),
                                      });

                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              '🎉 Terima kasih! Feedback kamu terkirim.'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              const FeedbackResultScreen(),
                                        ),
                                      );
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF4B6EF6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 5,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

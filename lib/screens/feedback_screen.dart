import 'package:car_rental_project/database/database_helper.dart';
import 'package:car_rental_project/screens/feedback_result_screen.dart';
import 'package:flutter/material.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _feedbackCtrl = TextEditingController();
  double _rating = 4.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Pesan & Kesan'),
        centerTitle: true,
        backgroundColor: const Color(0xFF4B6EF6),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🩵 HEADER SEPERTI PROFILE
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF4B6EF6),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 38,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: const Icon(
                      Icons.feedback_outlined,
                      size: 38,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "Bagikan Pendapatmu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Kami ingin tahu kesan dan saran kamu ✨",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 💬 FORM DALAM CARD PUTIH (SEPERTI PROFILE DETAIL)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                  
                        // Rating
                        Text(
                          'Seberapa puas kamu?',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white70 : Colors.black87,
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
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 32,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),

                        // Pesan
                        TextFormField(
                          controller: _feedbackCtrl,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Tulis saran atau kesanmu',
                            alignLabelWithHint: true,
                            prefixIcon: const Icon(Icons.edit_note_outlined,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? 'Tuliskan pendapatmu minimal sedikit ya!'
                              : null,
                        ),
                        const SizedBox(height: 30),

                        // Tombol Kirim
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                await DatabaseHelper.instance.insertFeedback({
                                  'user_id': 1,
                                  'message': _feedbackCtrl.text,
                                  'created_at':
                                      DateTime.now().toIso8601String(),
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '🎉 Terima kasih, ${_nameCtrl.text}! Feedback kamu terkirim.',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                _nameCtrl.clear();
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
                            icon: const Icon(Icons.send, color: Colors.white),
                            label: const Text(
                              'Kirim Feedback',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4B6EF6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

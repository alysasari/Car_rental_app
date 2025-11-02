import 'package:flutter/material.dart';

class StrukOrder extends StatelessWidget {
  final Map<String, dynamic> receipt;
  const StrukOrder({Key? key, required this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0E1321) : const Color(0xFFF6F7FB);
    final cardColor = isDark ? const Color(0xFF1B2235) : Colors.white;
    const accent = Color(0xFF4B6EF6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // ✅ Animated Success Icon
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: Color(0x334B6EF6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: accent,
                  size: 80,
                ),
              ),
              const SizedBox(height: 16),

              // ✅ Success Message
              const Text(
                "Booking Successful!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Your booking has been confirmed 🎉",
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 28),

              // 🧾 Receipt Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      "Booking Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Divider(thickness: 1, color: Color(0xFFE0E0E0)),

                    const SizedBox(height: 10),
                    _row('🚗 Car', receipt['carName']),
                    _row('🏷️ Brand', receipt['brand']),
                    _row('📅 Date', receipt['date']),
                    _row('⏰ Time', '${receipt['time']} (${receipt['timezone']})'),
                    _row('💳 Payment', receipt['payment']),
                    _row('💵 Currency', receipt['currency']),
                    _row('💰 Amount', 'Rp ${receipt['amount']}'),

                    const SizedBox(height: 14),
                    const Divider(thickness: 1, color: Color(0xFFE0E0E0)),

                    const SizedBox(height: 8),
                    Text(
                      "Thank you for choosing our service!",
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // 🔙 Back Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accent,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 5,
                    shadowColor: Colors.blueAccent.withOpacity(0.3),
                  ),
                  child: const Text(
                    "Back to Home",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 15,
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: Text(
              value ?? '-',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

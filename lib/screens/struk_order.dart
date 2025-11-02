import 'package:flutter/material.dart';

class StrukOrder extends StatelessWidget {
  final Map<String, dynamic> receipt;
  const StrukOrder({Key? key, required this.receipt}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Confirmed'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.check_circle, size: 80, color: Color(0xFF4B6EF6)),
            const SizedBox(height: 12),
            const Text(
              'Booking Successful!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            _row('Car', receipt['carName']),
            _row('Brand', receipt['brand']),
            _row('Date', receipt['date']),
            _row('Time', '${receipt['time']} (${receipt['timezone']})'),
            _row('Payment', receipt['payment']),
            _row('Currency', receipt['currency']),
            _row('Amount', receipt['amount'].toString()),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // ✅ Langsung balik ke home tanpa insert ulang
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B6EF6),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Back to Home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
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
          Text(label, style: const TextStyle(color: Colors.black54)),
          Flexible(
            child: Text(
              value ?? '-',
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

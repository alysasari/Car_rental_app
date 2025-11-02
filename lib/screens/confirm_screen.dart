// lib/screens/confirm_screen.dart
import 'package:car_rental_project/database/database_helper.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:car_rental_project/models/car_model.dart';
import 'package:car_rental_project/screens/struk_order.dart';


class ConfirmScreen extends StatefulWidget {
  final CarModel car;
  final String date;
  final String time;
  final String timezone;
  final String paymentMethod;
  final String? cardLabel;

  const ConfirmScreen({
    Key? key,
    required this.car,
    required this.date,
    required this.time,
    required this.timezone,
    required this.paymentMethod,
    this.cardLabel,
  }) : super(key: key);

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  String targetCurrency = 'IDR';
  final Map<String, double> dummyRates = {
    'IDR': 1.0,
    'USD': 0.000068, // example
    'JPY': 0.0093,
  };

  DateTime parseSelectedDateTime() {
    // date is yyyy-MM-dd, time is e.g. 07:00 AM
    final d = DateFormat('yyyy-MM-dd').parse(widget.date);
    final t = DateFormat('hh:mm a').parse(widget.time); // yields today time but we'll take hour/min
    return DateTime(d.year, d.month, d.day, t.hour, t.minute);
  }

  DateTime convertToZone(DateTime dt, String zone) {
    // Simple manual offset relative to WIB (UTC+7).
    // Assumes input dt is local / set as is. We'll simulate:
    switch (zone) {
      case 'WIB':
        return dt; // assume original is WIB for demo
      case 'WITA':
        return dt.add(const Duration(hours: 1));
      case 'WIT':
        return dt.add(const Duration(hours: 2));
      case 'London':
        return dt.subtract(const Duration(hours: 7)); // WIB->London approx
      default:
        return dt;
    }
  }

  String formatCurrency(double amount, String curr) {
    if (curr == 'IDR') {
      final f = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return f.format(amount);
    } else {
      final f = NumberFormat.simpleCurrency(name: curr);
      return f.format(amount * (dummyRates[curr] ?? 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final baseDt = parseSelectedDateTime();
    final zoneDt = convertToZone(baseDt, widget.timezone);
    final price = widget.car.price.toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking'), iconTheme: const IconThemeData(color: Colors.black), backgroundColor: Colors.blue, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          ListTile(
            leading: Image.network(widget.car.image, width: 64, height: 48, fit: BoxFit.cover, errorBuilder: (_,__,___) => const Icon(Icons.directions_car)),
            title: Text(widget.car.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${widget.car.brand} • ${widget.car.model}'),
            trailing: Text(formatCurrency(price, targetCurrency), style: const TextStyle(color: Color(0xFF4B6EF6), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 8),
            Text(DateFormat('dd MMM yyyy').format(baseDt)),
            const SizedBox(width: 16),
            const Icon(Icons.access_time, size: 16),
            const SizedBox(width: 8),
            Text(DateFormat('hh:mm a').format(zoneDt) + ' (${widget.timezone})'),
          ]),
          const SizedBox(height: 16),

          // Currency selector
          Row(
            children: [
              const Text('Currency:'),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: targetCurrency,
                items: dummyRates.keys.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                onChanged: (v) => setState(() => targetCurrency = v!),
              ),
            ],
          ),

          const SizedBox(height: 12),
          ListTile(
            title: const Text('Payment'),
            subtitle: Text(widget.paymentMethod + (widget.cardLabel != null ? ' • ${widget.cardLabel}' : '')),
          ),

          const Spacer(),

          ElevatedButton(
           onPressed: () async {
  // 📄 1️⃣ Buat data struk untuk ditampilkan di halaman sukses
  final receipt = {
    'carName': widget.car.name,
    'brand': widget.car.brand,
    'date': DateFormat('dd MMM yyyy').format(baseDt),
    'time': DateFormat('hh:mm a').format(zoneDt),
    'timezone': widget.timezone,
    'currency': targetCurrency,
    'amount': formatCurrency(price, targetCurrency),
    'payment': widget.paymentMethod,
  };

  // 🚗 2️⃣ Simpan order ke database
  final newOrder = {
    'user_id': 1, // ganti nanti sesuai user login
    'car_id': widget.car.id,
    'start_date': baseDt.toIso8601String(),
    'end_date': baseDt.add(const Duration(days: 1)).toIso8601String(),
    'pickup_time': widget.time,
    'status': 'Confirmed',
  };
  final orderId = await DatabaseHelper.instance.insertOrder(newOrder);

  // 💳 3️⃣ Simpan payment terkait order itu
  final payment = {
    'order_id': orderId,
    'method': widget.paymentMethod,
    'amount': price,
    'currency': targetCurrency,
    'status': 'Paid',
  };
  await DatabaseHelper.instance.insertPayment(payment);

  // 🧾 4️⃣ Simpan receipt (tanpa PDF dulu)
  final receiptData = {
    'order_id': orderId,
    'pdf_path': '', // nanti diisi setelah fitur PDF jadi
    'created_at': DateTime.now().toIso8601String(),
  };
  await DatabaseHelper.instance.insertReceipt(receiptData);

  // ✅ 5️⃣ Tampilkan halaman struk sukses
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (_) => StrukOrder(receipt: receipt)),
  );
}, child: null,
          )
        ]),
      ),
    );
  }
}

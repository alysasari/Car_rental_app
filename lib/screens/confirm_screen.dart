import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:car_rental_project/models/car_model.dart';
import 'package:car_rental_project/database/database_helper.dart';
import 'package:car_rental_project/screens/struk_order.dart';
import '../utils/session_manager.dart';

class ConfirmScreen extends StatefulWidget {
  final CarModel car;
  final String date;
  final String time;
  final String timezone;
  final String paymentMethod;
  final String? cardLabel;

  const ConfirmScreen({
    super.key,
    required this.car,
    required this.date,
    required this.time,
    required this.timezone,
    required this.paymentMethod,
    this.cardLabel,
  });

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  String targetCurrency = 'IDR';
  String selectedTimezone = 'WIB';
  late DateTime originalDateTime;

  final Map<String, double> dummyRates = {
    'IDR': 1.0,
    'USD': 0.000068,
    'JPY': 0.0093,
  };

  final Map<String, int> timezoneOffsets = {
    'WIB': 7,
    'WITA': 8,
    'WIT': 9,
    'London': 0,
    'Tokyo': 9,
  };

  @override
  void initState() {
    super.initState();
    selectedTimezone = widget.timezone;
    originalDateTime = _parseDateTime(widget.date, widget.time, widget.timezone);
  }

  DateTime _parseDateTime(String date, String time, String tz) {
  try {
  
    return DateFormat('yyyy-MM-dd hh:mm a').parse('$date $time');
  } catch (_) {
    try {
   
      return DateFormat('yyyy-MM-dd HH:mm').parse('$date $time');
    } catch (_) {
    
      return DateTime.now();
    }
  }
}

  DateTime _convertToTimezone(DateTime base, String fromTz, String toTz) {
    final fromOffset = timezoneOffsets[fromTz] ?? 7;
    final toOffset = timezoneOffsets[toTz] ?? 7;
    final diff = toOffset - fromOffset;
    return base.add(Duration(hours: diff));
  }

  String formatCurrency(double amount, String curr) {
    if (curr == 'IDR') {
      final f =
          NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      return f.format(amount);
    } else {
      final f = NumberFormat.simpleCurrency(name: curr);
      return f.format(amount * (dummyRates[curr] ?? 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = widget.car.price.toDouble();
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0E1321) : const Color(0xFFF5F6FA);
    final cardColor = isDark ? const Color(0xFF1A1F2E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;

    final convertedDateTime =
        _convertToTimezone(originalDateTime, widget.timezone, selectedTimezone);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: PreferredSize(
  preferredSize: const Size.fromHeight(65),
  child: AppBar(
    automaticallyImplyLeading: false,
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF4B6EF6), Color(0xFF7D9AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    elevation: 4,
    shadowColor: Colors.black26,
    centerTitle: true,
    title: const Text(
      'Confirm Booking',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    leading: IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: Colors.white,
      ),
      onPressed: () => Navigator.pop(context),
    ),
  ),
),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //  Car Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      widget.car.image,
                      width: 90,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.car_rental, size: 50),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.car.name,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: textColor)),
                        Text(
                          '${widget.car.brand} • ${widget.car.model}',
                          style: TextStyle(
                              fontSize: 13,
                              color:
                                  isDark ? Colors.white70 : Colors.grey[700]),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          formatCurrency(price, targetCurrency),
                          style: const TextStyle(
                              color: Color(0xFF4B6EF6),
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 📅 Date & Time Info
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.calendar_month, color: Color(0xFF4B6EF6)),
                    const SizedBox(width: 10),
                    Text(DateFormat('EEE, dd MMM yyyy').format(convertedDateTime),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                  ]),
                  const SizedBox(height: 14),
                  Row(children: [
                    const Icon(Icons.access_time, color: Color(0xFF4B6EF6)),
                    const SizedBox(width: 10),
                    Text(DateFormat('hh:mm a').format(convertedDateTime),
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                  ]),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      const Text('Timezone:',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(width: 10),
                      DropdownButton<String>(
                        value: selectedTimezone,
                        borderRadius: BorderRadius.circular(12),
                        items: timezoneOffsets.keys
                            .map(
                              (tz) => DropdownMenuItem(
                                value: tz,
                                child: Text(tz),
                              ),
                            )
                            .toList(),
                        onChanged: (v) =>
                            setState(() => selectedTimezone = v!),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment & Currency
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Payment Details',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.credit_card, color: Color(0xFF4B6EF6)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${widget.paymentMethod} ${widget.cardLabel != null ? "• ${widget.cardLabel}" : ""}',
                          style: TextStyle(color: textColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.monetization_on,
                          color: Color(0xFF4B6EF6)),
                      const SizedBox(width: 8),
                      const Text('Currency: ',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      DropdownButton<String>(
                        value: targetCurrency,
                        items: dummyRates.keys
                            .map((k) =>
                                DropdownMenuItem(value: k, child: Text(k)))
                            .toList(),
                        onChanged: (v) => setState(() => targetCurrency = v!),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4B6EF6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () async {
                  final receipt = {
                    'carName': widget.car.name,
                    'brand': widget.car.brand,
                    'date': DateFormat('dd MMM yyyy').format(convertedDateTime),
                    'time': DateFormat('hh:mm a').format(convertedDateTime),
                    'timezone': selectedTimezone,
                    'currency': targetCurrency,
                    'amount': formatCurrency(price, targetCurrency),
                    'payment': widget.paymentMethod,
                  };

                    final userData = await SessionManager.getUserData();
                    final idStr = userData['id'];
                    final userId = int.tryParse(idStr ?? '') ?? 1;

                    // Ensure the car exists in the local `cars` table so history JOIN can find name/image
                    try {
                      final carIdInt = int.tryParse(widget.car.id) ?? widget.car.id.hashCode;
                      await DatabaseHelper.instance.insertCars([
                        {
                          'id': carIdInt,
                          'name': widget.car.name,
                          'brand': widget.car.brand,
                          'model': widget.car.model,
                          'year': widget.car.year,
                          'price': widget.car.price,
                          'image': widget.car.image,
                          'location': widget.car.location,
                          'latitude': widget.car.latitude ?? 0.0,
                          'longitude': widget.car.longitude ?? 0.0,
                          'transmission': widget.car.transmission,
                          'seats': widget.car.seats,
                          'description': widget.car.description,
                        }
                      ]);
                    } catch (e) {
                      // non-fatal; continue to create order even if car insert fails
                      print('Warning: failed to upsert car before order: $e');
                    }

                    final newOrder = {
                      'user_id': userId,
                      'car_id': int.tryParse(widget.car.id) ?? widget.car.id.hashCode,
                      'start_date': convertedDateTime.toIso8601String(),
                      'end_date': convertedDateTime
                          .add(const Duration(days: 1))
                          .toIso8601String(),
                      'pickup_time': DateFormat('hh:mm a').format(convertedDateTime),
                      'status': 'Confirmed',
                    };

                  final orderId =
                      await DatabaseHelper.instance.insertOrder(newOrder);

                  final payment = {
                    'order_id': orderId,
                    'method': widget.paymentMethod,
                    'amount': price,
                    'currency': targetCurrency,
                    'status': 'Paid',
                  };
                  await DatabaseHelper.instance.insertPayment(payment);

                  await DatabaseHelper.instance.insertReceipt({
                    'order_id': orderId,
                    'pdf_path': '',
                    'created_at': DateTime.now().toIso8601String(),
                  });

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => StrukOrder(receipt: receipt)),
                  );
                },
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

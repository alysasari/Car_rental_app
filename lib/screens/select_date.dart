// lib/screens/select_date.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:car_rental_project/models/car_model.dart';
import 'package:car_rental_project/screens/payment_screen.dart';

class SelectDateScreen extends StatefulWidget {
  final CarModel car;
  const SelectDateScreen({Key? key, required this.car}) : super(key: key);

  @override
  _SelectDateScreenState createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  DateTime _selectedDate = DateTime.now();
  bool isMorningSelected = false;
  bool isEveningSelected = false;
  String? selectedTime;
  String timezone = 'WIB'; // default, user bisa ubah di confirm/payment nanti

  List<String> morningTimes = ['07:00 AM', '08:00 AM', '09:00 AM', '10:00 AM'];
  List<String> eveningTimes = ['05:00 PM', '06:00 PM', '07:00 PM', '08:00 PM'];

  @override
  Widget build(BuildContext context) {
    final car = widget.car;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Date'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Calendar
              CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                onDateChanged: (date) => setState(() => _selectedDate = date),
              ),
              const SizedBox(height: 20),

              // Morning / Evening
              Row(
                children: [
                  Expanded(child: _buildSessionButton("Morning", isMorningSelected, () {
                    setState(() {
                      isMorningSelected = true;
                      isEveningSelected = false;
                      selectedTime = null;
                    });
                  })),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSessionButton("Evening", isEveningSelected, () {
                    setState(() {
                      isEveningSelected = true;
                      isMorningSelected = false;
                      selectedTime = null;
                    });
                  })),
                ],
              ),
              const SizedBox(height: 20),

              // Time slots (after session chosen)
              if (isMorningSelected || isEveningSelected)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: (isMorningSelected ? morningTimes : eveningTimes)
                      .map((time) => ChoiceChip(
                            label: Text(time),
                            selected: selectedTime == time,
                            onSelected: (_) => setState(() => selectedTime = time),
                          ))
                      .toList(),
                ),

              const SizedBox(height: 30),

              // Book Now -> navigasi ke PaymentScreen
              if (selectedTime != null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4B6EF6),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    // buat object payload sederhana
                    final formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PaymentScreen(
                          car: car,
                          date: formattedDate,
                          time: selectedTime!,
                          timezone: timezone,
                        ),
                      ),
                    );
                  },
                  child: const Text('Book Now', style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.deepPurple.shade100 : Colors.white,
          border: Border.all(color: isSelected ? Colors.deepPurple.shade300 : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(text, style: TextStyle(color: isSelected ? Colors.deepPurple : Colors.black, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

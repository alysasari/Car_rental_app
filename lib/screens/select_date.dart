import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:car_rental_project/models/car_model.dart';
import 'package:car_rental_project/screens/payment_screen.dart';

class SelectDateScreen extends StatefulWidget {
  final CarModel car;
  const SelectDateScreen({Key? key, required this.car}) : super(key: key);

  @override
  State<SelectDateScreen> createState() => _SelectDateScreenState();
}

class _SelectDateScreenState extends State<SelectDateScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _selectedTime;
  String timezone = 'WIB';

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF4B6EF6),
              surface: isDark ? const Color(0xFF1B2235) : Colors.white,
              onSurface: isDark ? Colors.white : Colors.black,
            ),
            dialogBackgroundColor:
                isDark ? const Color(0xFF171C2C) : Colors.white,
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final car = widget.car;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final surfaceColor =
        isDark ? const Color(0xFF0E1321) : const Color(0xFFF6F7FB);
    final cardColor =
        isDark ? const Color(0xFF1B2235) : const Color(0xFFFFFFFF);

    return Scaffold(
      backgroundColor: surfaceColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              //  HEADER
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF29314A), const Color(0xFF1B2235)]
                        : [const Color(0xFF4B6EF6), const Color(0xFF7D9AFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Select Date & Time",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "Choose when to rent your car",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              //DATE PICKER 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.15),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.light(
                        primary: Colors.black.withOpacity(0.3),
                        onPrimary: Colors.white,
                        surface: cardColor,
                        onSurface: textColor,
                      ),
                     datePickerTheme: DatePickerThemeData(
  backgroundColor: cardColor,
  headerForegroundColor: textColor,
  dayForegroundColor:
      MaterialStateProperty.resolveWith<Color>(
    (states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.red;
      }
      if (states.contains(MaterialState.disabled)) {
        return Colors.grey.shade400;
      }
      return textColor;
    },
  ),
  dayBackgroundColor:
      MaterialStateProperty.resolveWith<Color>(
    (states) {
      if (states.contains(MaterialState.selected)) {
        return Colors.redAccent; 
      }
   
      return Colors.transparent;
    },
  ),
),

                    ),
                    child: CalendarDatePicker(
                      initialDate: _selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                      onDateChanged: (date) =>
                          setState(() => _selectedDate = date),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // TIME PICKER
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () => _pickTime(context),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isDark
                            ? [const Color(0xFF232A44), const Color(0xFF171C2C)]
                            : [Colors.white, const Color(0xFFE8EDFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: isDark
                              ? Colors.black.withOpacity(0.25)
                              : Colors.grey.withOpacity(0.15),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled_rounded,
                                color: Color(0xFF4B6EF6)),
                            const SizedBox(width: 12),
                            Text(
                              _selectedTime == null
                                  ? "Tap to select time"
                                  : _selectedTime!.format(context),
                              style: TextStyle(
                                color: _selectedTime == null
                                    ? Colors.grey
                                    : textColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.chevron_right_rounded,
                            color: isDark ? Colors.white38 : Colors.black26),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              //CONTINUE BUTTON 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedOpacity(
                  opacity: _selectedTime != null ? 1.0 : 0.5,
                  duration: const Duration(milliseconds: 300),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B6EF6),
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6,
                    ),
                    onPressed: _selectedTime == null
                        ? null
                        : () {
                            final formattedDate = DateFormat('yyyy-MM-dd')
                                .format(_selectedDate);
                            final timeStr = _selectedTime!.format(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PaymentScreen(
                                  car: car,
                                  date: formattedDate,
                                  time: timeStr,
                                  timezone: timezone,
                                ),
                              ),
                            );
                          },
                    child: const Text(
                      'Continue to Payment',
                      style: TextStyle(fontSize: 17, color: Colors.white),
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
}

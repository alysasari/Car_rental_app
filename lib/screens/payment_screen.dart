// lib/screens/payment_screen.dart
import 'package:flutter/material.dart';
import 'package:car_rental_project/models/car_model.dart';
import 'package:car_rental_project/screens/addcard_screen.dart';
import 'package:car_rental_project/screens/confirm_screen.dart';

class PaymentScreen extends StatefulWidget {
  final CarModel car;
  final String date;
  final String time;
  final String timezone;

  const PaymentScreen({
    Key? key,
    required this.car,
    required this.date,
    required this.time,
    required this.timezone,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedMethod = 'Card'; // Card, Cash, E-Wallet
  String? selectedSavedCard; // in demo we won't persist cards, placeholder

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // summary kecil
            Row(
              children: [
                Expanded(
                  child: Text(widget.car.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                Text('Rp ${widget.car.price}/day', style: const TextStyle(color: Color(0xFF4B6EF6), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),

            // Methods
            _methodTile('Card', Icons.credit_card),
            _methodTile('E-Wallet', Icons.account_balance_wallet),
            _methodTile('Cash', Icons.money),

            const SizedBox(height: 20),

            if (selectedMethod == 'Card')
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Add New Card'),
                    onPressed: () async {
                      final cardData = await Navigator.push<Map<String,String>>(
                        context,
                        MaterialPageRoute(builder: (_) => const AddCardScreen()),
                      );
                      if (cardData != null) {
                        // for demo we set a simple representation
                        setState(() => selectedSavedCard = '${cardData['brand']} • **** ${cardData['last4']}');
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  if (selectedSavedCard != null)
                    ListTile(
                      leading: const Icon(Icons.credit_card),
                      title: Text(selectedSavedCard!),
                      trailing: TextButton(onPressed: () => setState(() => selectedSavedCard = null), child: const Text('Remove')),
                    ),
                ],
              ),

            const Spacer(),

            ElevatedButton(
              onPressed: () {
                // langsung lanjut ke confirm screen dengan semua data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmScreen(
                      car: widget.car,
                      date: widget.date,
                      time: widget.time,
                      timezone: widget.timezone,
                      paymentMethod: selectedMethod,
                      cardLabel: selectedSavedCard,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4B6EF6),
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Pay Now', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodTile(String method, IconData icon) {
    final selected = selectedMethod == method;
    return ListTile(
      onTap: () => setState(() => selectedMethod = method),
      leading: Icon(icon, color: selected ? const Color(0xFF4B6EF6) : null),
      title: Text(method),
      trailing: selected ? const Icon(Icons.check, color: Color(0xFF4B6EF6)) : null,
      tileColor: selected ? Colors.blue.shade50 : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    );
  }
}

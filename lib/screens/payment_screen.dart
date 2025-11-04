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
  String selectedMethod = 'Card';
  String? selectedSavedCard;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0E1321) : const Color(0xFFF6F7FB);
    final cardColor = isDark ? const Color(0xFF171C2C) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    const accent = Color(0xFF4B6EF6);

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // HEADER 
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF29314A), const Color(0xFF1B2235)]
                        : [const Color(0xFF4B6EF6), const Color(0xFF7D9AFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                   
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),

                    const SizedBox(width: 14),

              
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            "Payment",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Select your payment method",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // SUMMARY CARD
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: isDark ? Colors.black.withOpacity(0.28) : Colors.grey.withOpacity(0.12),
                        blurRadius: 10,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 80,
                          height: 56,
                          child: Image.network(
                            widget.car.image,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: isDark ? const Color(0xFF0B1220) : Colors.grey[200],
                              child: Icon(Icons.directions_car_outlined, color: isDark ? Colors.white54 : Colors.black26),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.car.name,
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${widget.car.brand} • ${widget.car.location}',
                              style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.grey[700],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rp ${widget.car.price}/day',
                        style: const TextStyle(
                          color: accent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _methodTile('Card', Icons.credit_card, isDark, cardColor, accent),
                    const SizedBox(height: 12),
                    _methodTile('E-Wallet', Icons.account_balance_wallet_rounded, isDark, cardColor, accent),
                    const SizedBox(height: 12),
                    _methodTile('Cash', Icons.payments_rounded, isDark, cardColor, accent),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              
              if (selectedMethod == 'Card') ...[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add New Card', style: TextStyle(color: Colors.white, fontSize: 15)),
                    onPressed: () async {
                      final cardData = await Navigator.push<Map<String, String>>(
                        context,
                        MaterialPageRoute(builder: (_) => const AddCardScreen()),
                      );
                      if (cardData != null) {
                        setState(() {
                          selectedSavedCard = '${cardData['brand']} • **** ${cardData['last4']}';
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      minimumSize: const Size(double.infinity, 52),
                      elevation: 4,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (selectedSavedCard != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 4)),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.credit_card, color: accent),
                              const SizedBox(width: 12),
                              Text(selectedSavedCard!, style: TextStyle(color: textColor, fontSize: 15)),
                            ],
                          ),
                          TextButton(onPressed: () => setState(() => selectedSavedCard = null), child: const Text('Remove', style: TextStyle(color: Colors.redAccent))),
                        ],
                      ),
                    ),
                  ),
              ],

              const SizedBox(height: 34),

              //  Pay Now button 
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(colors: [Color(0xFF4B6EF6), Color(0xFF3B55C3)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
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
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      minimumSize: const Size(double.infinity, 56),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: const Text('Pay Now', style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }


  Widget _methodTile(String method, IconData icon, bool isDark, Color cardColor, Color accentColor) {
    final bool isSelected = selectedMethod == method;

    return GestureDetector(
      onTap: () => setState(() => selectedMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? accentColor.withOpacity(0.12) : cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? accentColor : Colors.transparent, width: 2),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black.withOpacity(0.12) : Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: accentColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                method,
                style: TextStyle(
                  color: isSelected ? accentColor : (isDark ? Colors.white70 : Colors.black87),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: accentColor, size: 22),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:car_rental_project/models/order_model.dart';
import '../utils/receipt_generator.dart';

class HistoryDetailScreen extends StatefulWidget {
  final Order order;
  const HistoryDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _info(BuildContext context, String label, String value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
                fontSize: 15,
              )),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final order = widget.order;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Booking Details"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
            
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: order.carImage.isNotEmpty
                      ? Image.network(
                          order.carImage,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          height: 220,
                          color: isDark ? Colors.grey[800] : Colors.grey[300],
                          child: const Icon(Icons.directions_car,
                              size: 100, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 20),

                // Card Section for Info
                Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      if (!isDark)
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.carName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 8),
                      _info(context, "Start Date", order.startDate.split('T').first),
                      _info(context, "End Date", order.endDate.split('T').first),
                      _info(context, "Pickup Time", order.pickupTime),
                      _info(context, "Status", order.status),
                      _info(context, "Payment Method",
                          order.method.isNotEmpty ? order.method : "Not available"),
                      _info(context, "Currency",
                          order.currency.isNotEmpty ? order.currency : "-"),
                      _info(context, "Total Price",
                          "${order.currency} ${order.amount.toStringAsFixed(2)}"),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                //  Button
                GestureDetector(
                  onTap: () async {
                    try {
                      await ReceiptGenerator.generatePDF(order);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text("✅ Receipt downloaded successfully!")),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text("❌ Failed to download receipt: $e")),
                      );
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: double.infinity,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.blueGrey.shade600, Colors.blueAccent.shade400]
                            : [const Color(0xFF4B6EF6), const Color(0xFF6B8DFA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.download, color: Colors.white, size: 22),
                        SizedBox(width: 8),
                        Text(
                          "Download Receipt",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

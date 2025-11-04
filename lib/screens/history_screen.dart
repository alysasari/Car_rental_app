
import 'dart:ui';

import 'package:car_rental_project/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../models/order_model.dart';
import 'history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  List<Order> orders = [];
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final db = DatabaseHelper.instance;
    final result = await db.getUserHistory(1); 
    await Future.delayed(const Duration(milliseconds: 300));
    setState(() {
      orders = result.map((e) => Order.fromMap(e)).toList();
      _isLoading = false;
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _cardColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? const Color(0xFF1C2431) : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B1220) : Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
        
Container(
  height: 160,
  padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
  decoration: BoxDecoration(
    gradient: LinearGradient(
      colors: isDark
          ? [const Color(0xFF0F172A), const Color(0xFF071028)] // dark mode
          : [const Color(0xFF4B6EF6), const Color(0xFF93C5FD)], // light mode
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(36)),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(isDark ? 0.35 : 0.08),
        blurRadius: 12,
        offset: const Offset(0, 6),
      ),
    ],
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Booking History",
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.6,
            ),
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.dark_mode : Icons.light_mode_outlined,
              color: Colors.white,
            ),
            onPressed: () {
              final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
              themeProvider.toggleTheme(!themeProvider.isDarkMode);
            },
          ),
        ],
      ),
      const SizedBox(height: 16),
   
     
    ],
  ),
),


            // BODY
            RefreshIndicator(
              onRefresh: _loadHistory,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: orders.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 180),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.inbox_outlined,
                                          size: 72,
                                          color: isDark
                                              ? Colors.white38
                                              : Colors.grey.shade500),
                                      const SizedBox(height: 14),
                                      Text(
                                        "Belum ada riwayat pemesanan",
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: isDark
                                              ? Colors.white70
                                              : Colors.grey.shade700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : ListView.builder(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 180, 16, 20),
                                itemCount: orders.length,
                                itemBuilder: (context, index) {
                                  final o = orders[index];
                                  return AnimatedContainer(
                                    duration:
                                        const Duration(milliseconds: 300),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                      color: _cardColor(context),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: isDark
                                              ? Colors.black.withOpacity(0.4)
                                              : Colors.grey.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white.withOpacity(0.05)
                                            : Colors.black.withOpacity(0.05),
                                      ),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.all(14),
                                      leading: Hero(
                                        tag: 'car_${o.id}',
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: o.carImage.isNotEmpty
                                              ? Image.network(
                                                  o.carImage,
                                                  width: 70,
                                                  height: 70,
                                                  fit: BoxFit.cover,
                                                  errorBuilder:
                                                      (_, __, ___) =>
                                                          const Icon(
                                                    Icons.car_rental,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                )
                                              : Container(
                                                  width: 70,
                                                  height: 70,
                                                  color: Colors.grey.shade300,
                                                  child: const Icon(
                                                    Icons.directions_car,
                                                    size: 40,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        o.carName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.grey.shade900,
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 6),
                                        child: Text(
                                          "${o.startDate.split('T').first} → ${o.endDate.split('T').first}\nStatus: ${o.status}",
                                          style: TextStyle(
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.grey.shade700,
                                            height: 1.5,
                                            fontSize: 13.5,
                                          ),
                                        ),
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? Colors.white.withOpacity(0.08)
                                              : Colors.blue.shade50,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                            Icons.arrow_forward_ios_rounded,
                                            size: 18,
                                            color: isDark
                                                ? Colors.white70
                                                : Colors.blue.shade600),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                HistoryDetailScreen(order: o),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

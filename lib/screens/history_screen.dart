import 'dart:ui';

import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/order_model.dart';
import 'history_detail_screen.dart';
import '../utils/session_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));

    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final db = DatabaseHelper.instance;
    final userData = await SessionManager.getUserData();
    final idStr = userData['id'];
    if (idStr == null) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        orders = [];
        _isLoading = false;
      });
      _controller.forward();
      return;
    }
    final userId = int.tryParse(idStr) ?? 1;
    final result = await db.getUserHistory(userId);

    try {
      print('🔎 getUserHistory returned ${result.length} rows for userId=$userId');
      if (result.isNotEmpty) print('🔎 sample row: ${result.first}');
    } catch (e) {
      print('Error printing history debug info: $e');
    }

    try {
      for (var row in result) {
        final carName = row['car_name'];
        if ((carName == null || carName.toString().isEmpty) && row['car_id'] != null) {
          final carIdVal = row['car_id'];
          int? carId;
          if (carIdVal is int) carId = carIdVal;
          else if (carIdVal is String) carId = int.tryParse(carIdVal);
          if (carId != null) {
            final carRow = await db.getCarById(carId);
            if (carRow != null) {
              row['car_name'] = carRow['name'] ?? '';
              row['car_image'] = carRow['image'] ?? '';
            }
          }
        }
      }
    } catch (e) {
      print('Error filling car details: $e');
    }

    await Future.delayed(const Duration(milliseconds: 200));
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
        child: RefreshIndicator(
          onRefresh: _loadHistory,
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                automaticallyImplyLeading: false,
                expandedHeight: 120,
                pinned: false,
                floating: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: const BoxDecoration(
                      color: Color(0xFF4A90E2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(22),
                        bottomRight: Radius.circular(22),
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 10,
                          offset: Offset(0, 4),
                          color: Colors.black26,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.fromLTRB(16, 36, 16, 16),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "History",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: 6),
                        
                      ],
                    ),
                  ),
                ),
              ),

              if (_isLoading) ...[
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: CircularProgressIndicator()),
                )
              ] else if (orders.isEmpty) ...[
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 72,
                            color: isDark ? Colors.white38 : Colors.grey.shade500),
                        const SizedBox(height: 14),
                        Text(
                          "Belum ada riwayat pemesanan",
                          style: TextStyle(
                            fontSize: 16,
                            color: isDark ? Colors.white70 : Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ] else ...[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final o = orders[index];
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: _cardColor(context),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: isDark ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            border: Border.all(
                              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(14),
                            leading: Hero(
                              tag: 'car_${o.id}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: o.carImage.isNotEmpty
                                    ? Image.network(
                                        o.carImage,
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) => const Icon(
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
                                color: isDark ? Colors.white : Colors.grey.shade900,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                "${o.startDate.split('T').first} → ${o.endDate.split('T').first}\nStatus: ${o.status}",
                                style: TextStyle(
                                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                                  height: 1.5,
                                  fontSize: 13.5,
                                ),
                              ),
                            ),
                            trailing: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withOpacity(0.08) : Colors.blue.shade50,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.arrow_forward_ios_rounded,
                                  size: 18, color: isDark ? Colors.white70 : Colors.blue.shade600),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HistoryDetailScreen(order: o),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: orders.length,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

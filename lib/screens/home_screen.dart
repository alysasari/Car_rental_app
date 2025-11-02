import 'package:car_rental_project/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental_project/models/car_model.dart';
import 'package:car_rental_project/services/api_service.dart';
import 'package:car_rental_project/database/database_helper.dart';
import 'car_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<CarModel> cars = [];
  List<CarModel> filtered = [];
  bool loading = true;
  String query = '';
  String selectedBrand = '';

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    setState(() => loading = true);
    final db = DatabaseHelper.instance;

    final raw = await ApiService.fetchCars();
    if (raw.isEmpty) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to load data')),
        );
      }
      return;
    }

    final list = raw.map((e) => CarModel.fromJson(e)).toList();
    await db.insertCars(raw);
    if (mounted) {
      setState(() {
        cars = list;
        filtered = list;
        loading = false;
      });
    }
  }

  void _applyFilter() {
    final q = query.trim().toLowerCase();
    setState(() {
      filtered = cars.where((c) {
        final matchesQ = q.isEmpty ||
            c.name.toLowerCase().contains(q) ||
            c.brand.toLowerCase().contains(q);
        final matchesBrand = selectedBrand.isEmpty || c.brand == selectedBrand;
        return matchesQ && matchesBrand;
      }).toList();
    });
  }

  List<String> getUniqueBrands() {
    final s = <String>{};
    for (var c in cars) s.add(c.brand);
    return s.toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDark;
    final brands = getUniqueBrands();

    final logoMap = {
      'Toyota': 'assets/brands/toyota.jpg',
      'Honda': 'assets/brands/honda.jpg',
      'Mitsubishi': 'assets/brands/mitsubishi.png',
      'Daihatsu': 'assets/brands/daihatsu.jpg',
      'Suzuki': 'assets/brands/suzuki.png',
      'Kia': 'assets/brands/kia.png',
      'Hyundai': 'assets/brands/hyundai.jpg',
      'Wuling': 'assets/brands/wuling.jpg',
      'Mazda': 'assets/brands/mazda.jpg',
    };

    return Scaffold(
      extendBodyBehindAppBar: true,

      // 🌈 Gradient background biar lembut kayak UI modern
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                : [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: loading
            ? Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadCars,
                color: Theme.of(context).colorScheme.secondary,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 120, 16, 16),
                  children: [
                    // 🔍 Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Theme.of(context).cardColor.withOpacity(0.2),
                        ),
                      ),
                      child: TextField(
                        style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.color,
                        ),
                        onChanged: (v) {
                          query = v;
                          _applyFilter();
                        },
                        decoration: InputDecoration(
                          hintText: 'Search...',
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color
                                ?.withOpacity(0.6),
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          suffixIcon: Icon(
                            Icons.filter_alt,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 🏎️ Top Brands
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Top Brands',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: brands.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(width: 12),
                        itemBuilder: (context, i) {
                          final b = brands[i];
                          final logo =
                              logoMap[b] ?? 'assets/brands/default.png';
                          final isSelected = selectedBrand == b;
                          return GestureDetector(
                            onTap: () {
                              setState(() => selectedBrand = b);
                              _applyFilter();
                            },
                            child: Container(
                              width: 70,
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.3)
                                    : Theme.of(context)
                                        .cardColor
                                        .withOpacity(0.05),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Theme.of(context)
                                      .cardColor
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    logo,
                                    width: 30,
                                    height: 30,
                                    fit: BoxFit.contain,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    b,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 28),

                    // 🚗 All Cars
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Cars',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'View All',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    ...filtered.map((car) => _buildCarCard(context, car, isDark)),
                  ],
                ),
              ),
      ),

      // 🌈 Gradient AppBar
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: ThemeProvider.appBarGradient,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Select or search your\nfavourite vehicle',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: Colors.white,
            ),
            onPressed: () => themeProvider.toggleTheme(!isDark),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 12),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/images/profile.png'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(BuildContext context, CarModel car, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: isDark
            ? null
            : LinearGradient(
                colors: [
                  Colors.blue.shade50.withOpacity(0.9),
                  Colors.white.withOpacity(0.95),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        color: isDark ? Colors.white.withOpacity(0.05) : null,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.blue.shade100.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : Colors.blue.withOpacity(0.1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            car.image,
            width: 70,
            height: 70,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          car.name,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
        ),
        subtitle: Text(
          '${car.location} • ${car.transmission}',
          style: TextStyle(
            color: isDark ? Colors.white70 : Colors.grey.shade700,
          ),
        ),
        trailing: Text(
          'Rp ${car.price}',
          style: TextStyle(
            color: isDark
                ? Colors.lightBlueAccent
                : const Color(0xFF2563EB),
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
        ),
      ),
    );
  }
}

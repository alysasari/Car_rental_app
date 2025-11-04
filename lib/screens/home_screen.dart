
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_rental_project/theme_provider.dart';
import 'package:car_rental_project/models/car_model.dart';
import 'package:car_rental_project/services/api_service.dart';
import 'package:car_rental_project/screens/car_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<CarModel>> cars;
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';
  Set<String> favoriteCarIds = {};
  String selectedBrand = '';
  double maxPrice = 999999999;
  String selectedTransmission = '';
  final Map<String, bool> _pressed = {};

  @override
  void initState() {
    super.initState();
    cars = _loadCars();
    _loadFavorites();
  }

  Future<List<CarModel>> _loadCars() async {
    final data = await ApiService.fetchCars();
    return data.map((json) => CarModel.fromJson(json)).toList();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('favorites') ?? [];
    setState(() {
      favoriteCarIds = saved.toSet();
    });
  }

  Future<void> _toggleFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (favoriteCarIds.contains(id)) {
        favoriteCarIds.remove(id);
      } else {
        favoriteCarIds.add(id);
      }
    });
    await prefs.setStringList('favorites', favoriteCarIds.toList());
  }

  // ✅ Fixed filter modal
  void _openFilterDialog() {
    double localMaxPrice = maxPrice;
    String localTransmission = selectedTransmission;

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            if (localMaxPrice > 450) localMaxPrice = 450;
            if (localMaxPrice < 0) localMaxPrice = 0;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🔍 Filter Options',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                 
                  Slider(
                    value: localMaxPrice,
                    min: 0,
                    max: 450,
                    divisions: 30,
                    label: '≤ Rp ${localMaxPrice.round()} Ribu Rupiah',
                    activeColor: const Color(0xFF4B6EF6),
                    onChanged: (value) {
                      setModalState(() => localMaxPrice = value);
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text('≤ Rp ${localMaxPrice.round()} Ribu Rupiah'),
                  ),

                  const SizedBox(height: 16),
                  const Text('⚙️ Transmission'),
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      FilterChip(
                        label: const Text('Manual'),
                        selected: localTransmission == 'Manual',
                        selectedColor:
                            const Color(0xFF4B6EF6).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF4B6EF6),
                        onSelected: (selected) {
                          setModalState(() {
                            localTransmission = selected ? 'Manual' : '';
                          });
                        },
                      ),
                      const SizedBox(width: 12),
                      FilterChip(
                        label: const Text('Automatic'),
                        selected: localTransmission == 'Automatic',
                        selectedColor:
                            const Color(0xFF4B6EF6).withOpacity(0.2),
                        checkmarkColor: const Color(0xFF4B6EF6),
                        onSelected: (selected) {
                          setModalState(() {
                            localTransmission = selected ? 'Automatic' : '';
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline,
                        color: Colors.white),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4B6EF6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    onPressed: () {
                      setState(() {
                        maxPrice = localMaxPrice;
                        selectedTransmission = localTransmission;
                      });
                      Navigator.pop(context);
                    },
                    label: const Text(
                      'Apply Filter',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  List<String> _extractBrands(List<CarModel> list) {
    final s = <String>{};
    for (var c in list) s.add(c.brand);
    return s.toList();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDark ? const Color(0xFF0B1220) : const Color(0xFFF7FBFF),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() => cars = _loadCars());
            await cars;
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              _buildHeader(context, isDark),
              _sectionTitle('🏎️ _Top_Brands', isDark, reset: true),
              _brandList(isDark),
              _sectionTitle('🚘 _Available_Cars', isDark),
              _carList(isDark),
              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 22),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF071028)])
            : const LinearGradient(
                colors: [Color(0xFF4B6EF6), Color(0xFF93C5FD)]),
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
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Select or Search Your Favorite Vehicle 🚗',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: Icon(
                  themeProvider.isDarkMode
                      ? Icons.dark_mode
                      : Icons.light_mode_outlined,
                  color: Colors.white,
                ),
                onPressed: () =>
                    themeProvider.toggleTheme(!themeProvider.isDarkMode),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.white70),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        decoration: const InputDecoration(
                          hintText: 'Search vehicle name or brand...',
                          hintStyle: TextStyle(color: Colors.white70),
                          border: InputBorder.none,
                        ),
                        onChanged: (val) =>
                            setState(() => searchQuery = val.toLowerCase()),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list, color: Colors.white70),
                      onPressed: _openFilterDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, bool isDark, {bool reset = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.replaceAll('_', ' '),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          if (reset)
            GestureDetector(
              onTap: () => setState(() => selectedBrand = ''),
              child: const Text('View All',
                  style: TextStyle(color: Color(0xFF4B6EF6))),
            ),
        ],
      ),
    );
  }

  Widget _brandList(bool isDark) {
    return FutureBuilder<List<CarModel>>(
      future: cars,
      builder: (context, snap) {
        if (!snap.hasData) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final brandList = _extractBrands(snap.data!);
        return SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: brandList.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, i) {
              final b = brandList[i];
              final logoPath = 'assets/brands/${b.toLowerCase()}.jpg';
              final pngAlt = 'assets/brands/${b.toLowerCase()}.png';
              return _brandCard(b, logoPath, pngAlt, isDark);
            },
          ),
        );
      },
    );
  }

  Widget _brandCard(String brand, String jpgPath, String pngPath, bool isDark) {
    return GestureDetector(
      onTap: () => setState(
        () => selectedBrand = brand == selectedBrand ? '' : brand,
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        width: 92,
        decoration: BoxDecoration(
          color: selectedBrand == brand
              ? (isDark ? Colors.blueGrey[700] : Colors.white)
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedBrand == brand
                ? const Color(0xFF4B6EF6)
                : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              jpgPath,
              height: 38,
              width: 38,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Image.asset(
                pngPath,
                height: 38,
                width: 38,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.directions_car),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              brand,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _carList(bool isDark) {
    return FutureBuilder<List<CarModel>>(
      future: cars,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox(height: 80);
        final filteredCars = snapshot.data!.where((car) {
          final matchesSearch = car.name.toLowerCase().contains(searchQuery) ||
              car.brand.toLowerCase().contains(searchQuery);
          final matchesBrand =
              selectedBrand.isEmpty || car.brand == selectedBrand;
          final matchesTransmission = selectedTransmission.isEmpty ||
              car.transmission.toLowerCase() ==
                  selectedTransmission.toLowerCase();
          final matchesPrice = car.price <= maxPrice * 1000000;
          return matchesSearch &&
              matchesBrand &&
              matchesTransmission &&
              matchesPrice;
        }).toList();

        return Column(
          children: filteredCars.map((car) => _carCard(car, isDark)).toList(),
        );
      },
    );
  }

  Widget _carCard(CarModel car, bool isDark) {
    final idKey = 'car-${car.id}';
    _pressed.putIfAbsent(idKey, () => false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onHighlightChanged: (v) => setState(() => _pressed[idKey] = v),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => CarDetailScreen(car: car)),
        ),
        child: AnimatedScale(
          scale: _pressed[idKey]! ? 0.98 : 1,
          duration: const Duration(milliseconds: 120),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.black.withOpacity(0.4)
                      : Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(22)),
                  child: Image.network(
                    car.image,
                    height: 120,
                    width: 140,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey[300],
                      height: 120,
                      width: 140,
                      child: const Icon(Icons.car_rental, size: 44),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          car.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color:
                                isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${car.location} • ${car.transmission}',
                          style: TextStyle(
                            color:
                                isDark ? Colors.white70 : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Rp ${car.price}/day',
                          style: const TextStyle(
                            color: Color(0xFF4B6EF6),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    favoriteCarIds.contains(car.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: favoriteCarIds.contains(car.id)
                        ? Colors.redAccent
                        : (isDark ? Colors.white70 : Colors.grey[700]),
                  ),
                  onPressed: () => _toggleFavorite(car.id),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

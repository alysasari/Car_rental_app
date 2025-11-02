// lib/screens/car_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:car_rental_project/models/car_model.dart';
import 'package:car_rental_project/screens/select_date.dart';
import 'package:url_launcher/url_launcher.dart';

class CarDetailScreen extends StatelessWidget {
  final CarModel car;
  const CarDetailScreen({Key? key, required this.car}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🖼️ Gambar interaktif
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: InteractiveViewer(
                  panEnabled: true,
                  scaleEnabled: true,
                  minScale: 0.9,
                  maxScale: 4.0,
                  child: Image.network(
                    car.image,
                    height: 240,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: Colors.grey[200],
                      child: const Icon(Icons.directions_car, size: 64),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🏷️ Nama & harga
            Text(
              car.name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4B6EF6),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${car.brand} • ${car.model} • ${car.year}',
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              'Rp ${car.price}/day',
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            // 🚗 Info Row (background biru, ikon & teks putih)
            Row(
              children: [
                _infoBox(Icons.settings, car.transmission),
                const SizedBox(width: 8),
                _infoBox(Icons.event_seat, '${car.seats} seats'),
                const SizedBox(width: 8),
                _infoBox(Icons.location_on, car.location),
              ],
            ),
            const SizedBox(height: 20),

            // 📝 Deskripsi
            Text(
              car.description,
              style: const TextStyle(fontSize: 15, height: 1.4),
            ),
            const SizedBox(height: 24),

            // 🗺️ Embedded Map
            if (car.latitude != null && car.longitude != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  height: 230,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(car.latitude!, car.longitude!),
                      initialZoom: 13,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.tugas_project_pam',
                        subdomains: const ['a', 'b', 'c'],
                      ),
                      MarkerLayer(
                        markers: [
                          Marker(
                            point:
                                LatLng(car.latitude!, car.longitude!),
                            width: 60,
                            height: 60,
                            child: const Icon(
                              Icons.location_pin,
                              size: 40,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 13),

            // 🔵 Tombol Book Now
           ElevatedButton(
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SelectDateScreen(car: car),
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    minimumSize: const Size.fromHeight(50),
    backgroundColor: const Color(0xFF4B6EF6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: const Text(
    'Book Now',
    style: TextStyle(fontSize: 16, color: Colors.white),
  ),
),
            const SizedBox(height: 12),

            // 🗺️ Tombol buka lokasi eksternal
            TextButton.icon(
              onPressed: () async {
                if (car.latitude != null && car.longitude != null) {
                  final Uri url = Uri.parse(
                      'https://www.openstreetmap.org/?mlat=${car.latitude}&mlon=${car.longitude}&zoom=16');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url,
                        mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Could not open map')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Location not available')),
                  );
                }
              },
              icon: const Icon(Icons.map, color: Color(0xFF4B6EF6)),
              label: const Text('Open in Map',
                  style: TextStyle(color: Color(0xFF4B6EF6))),
            ),
          ],
        ),
      ),
    );
  }

  // 🔧 Info Box (Biru, teks & ikon putih)
  Widget _infoBox(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF4B6EF6),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 13, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

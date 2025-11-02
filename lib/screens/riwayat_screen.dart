import 'package:flutter/material.dart';

class RiwayatScreen extends StatelessWidget {
  const RiwayatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Riwayat Pemesanan',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildRiwayatCard(
            imageUrl:
                'https://cdn.pixabay.com/photo/2017/03/27/14/56/bmw-2178904_1280.jpg',
            name: 'BMW M4 Coupe',
            date: '25 Okt 2025',
            price: '\$180/day',
          ),
          _buildRiwayatCard(
            imageUrl:
                'https://cdn.pixabay.com/photo/2015/01/19/13/51/car-604019_1280.jpg',
            name: 'Lamborghini Huracan',
            date: '21 Okt 2025',
            price: '\$400/day',
          ),
          _buildRiwayatCard(
            imageUrl:
                'https://cdn.pixabay.com/photo/2012/05/29/00/43/car-49278_1280.jpg',
            name: 'Toyota Supra',
            date: '15 Okt 2025',
            price: '\$210/day',
          ),
        ],
      ),
    );
  }

  Widget _buildRiwayatCard({
    required String imageUrl,
    required String name,
    required String date,
    required String price,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 2,
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            width: 60,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text('Tanggal: $date'),
        trailing: Text(
          price,
          style: const TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

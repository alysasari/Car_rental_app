
class CarModel {
  final String id;
  final String name;
  final String brand;
  final String model;
  final int year;
  final int price;
  final String image;
  final String location;
 final double? latitude;
  final double? longitude;
  final String transmission;
  final int seats;
  final String description;

  CarModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    required this.year,
    required this.price,
    required this.image,
    required this.location,
    required this.longitude,
    required this.latitude,
    required this.transmission,
    required this.seats,
    required this.description,
  });


factory CarModel.fromJson(Map<String, dynamic> j) {
    double? parseDouble(dynamic v) {
      if (v == null) return null;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      if (v is String) return double.tryParse(v);
      return null;
    }
    
    return CarModel(
      id: j['id'].toString(),
      name: j['name'] ?? '',
      brand: j['brand'] ?? '',
      model: j['model'] ?? '',
      year: (j['year'] is int)
          ? j['year']
          : int.tryParse(j['year'].toString()) ?? 0,
      price: (j['price'] is int)
          ? j['price']
          : int.tryParse(j['price'].toString()) ?? 0,
      image: j['image'] ?? '',
      location: j['location'] ?? '',
      latitude: parseDouble(j['latitude']),
      longitude: parseDouble(j['longitude']),
      transmission: j['transmission'] ?? '',
      seats: (j['seats'] is int)
          ? j['seats']
          : int.tryParse(j['seats'].toString()) ?? 0,
      description: j['description'] ?? '',
    );
  }
}

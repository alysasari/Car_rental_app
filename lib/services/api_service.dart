import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl =
      "https://68fa28ecef8b2e621e7f0238.mockapi.io/cars/cars";

  static Future<List<Map<String, dynamic>>> fetchCars() async {
    try {
      final url = Uri.parse(baseUrl);
      final resp = await http.get(url).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  static Future<List<dynamic>> fetchCarsRaw() async {
  try {
      final url = Uri.parse(baseUrl);
      final resp = await http.get(url).timeout(const Duration(seconds: 10));
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data is List) return data;
      }
      return [];
    } catch (e) {
      print("FetchCarsRaw error: $e");
      return [];
    }
  }
}

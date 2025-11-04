import 'package:car_rental_project/database/database_helper.dart';
import 'package:car_rental_project/database/encryption_helper.dart';

class AuthService {
  /// REGISTER (menyimpan password terenkripsi)
  static Future<Map<String, dynamic>?> register(
      String name, String email, String password) async {
    final dbHelper = DatabaseHelper.instance;

    email = email.trim().toLowerCase();
    name = name.trim();

    // Cek email sudah terdaftar atau belum
    final existingUser = await dbHelper.getUserByEmail(email);
    if (existingUser != null) {
      return null; // email sudah digunakan
    }

    // Enkripsi password sebelum disimpan
    final encryptedPassword = EncryptionHelper.encryptText(password);

    // Simpan ke database
    final id = await dbHelper.insertUser({
      'name': name,
      'email': email,
      'password_hash': encryptedPassword,
    });

    if (id > 0) {
      return {
        'id': id,
        'name': name,
        'email': email,
      };
    }
    return null;
  }

  /// LOGIN (membandingkan password hasil dekripsi)
  static Future<Map<String, dynamic>?> login(
      String email, String password) async {
    final dbHelper = DatabaseHelper.instance;
    email = email.trim().toLowerCase();

    print("🔍 Login attempt for: $email");

  //  Cek semua user di database untuk debugging
  final allUsers = await dbHelper.getAllUsers();
  print("🧠 ALL USERS: $allUsers");

    // Cari user berdasarkan email
    final user = await dbHelper.getUserByEmail(email);
    if (user == null) return null;

    // Dekripsi password dari database
    final decryptedPassword =
        EncryptionHelper.decryptText(user['password_hash']);
     print("🔓 Decrypted password: $decryptedPassword");
  print("🧩 Input password: $password");


    // Bandingkan password input dengan hasil dekripsi
    if (password == decryptedPassword) {
      return {
        'id': user['id'],
        'name': user['name'],
        'email': user['email'],
      };
    }

  print("❌ Password salah untuk ${user['email']}");
    return null;
  }
}

import 'dart:developer';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "rent_smartv2.db";
  static const _databaseVersion = 1;

  static Database? _database;
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

 
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    log("🧩 Creating tables...");

 
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password_hash TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE cars (
        id INTEGER PRIMARY KEY,
        name TEXT,
        brand TEXT,
        model TEXT,
        year INTEGER,
        price INTEGER,
        image TEXT,
        location TEXT,
        latitude REAL,
        longitude REAL,
        transmission TEXT,
        seats INTEGER,
        description TEXT
      )
    ''');

 
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        car_id INTEGER,
        start_date TEXT,
        end_date TEXT,
        pickup_time TEXT,
        status TEXT,
        FOREIGN KEY(user_id) REFERENCES users(id),
        FOREIGN KEY(car_id) REFERENCES cars(id)
      )
    ''');

  
    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        method TEXT,
        amount REAL,
        currency TEXT,
        status TEXT,
        FOREIGN KEY(order_id) REFERENCES orders(id)
      )
    ''');

  
    await db.execute('''
      CREATE TABLE receipts (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id INTEGER,
        pdf_path TEXT,
        created_at TEXT,
        FOREIGN KEY(order_id) REFERENCES orders(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE feedbacks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER,
        message TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY(user_id) REFERENCES users(id)
      )
    ''');

    log("✅ Semua tabel berhasil dibuat");
  }


  // USER
  
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    final res = await db.query('users', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty ? res.first : null;
  }

  Future<int> deleteUserById(int id) async {
    final db = await database;
    return await db.delete('users', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateUserName(int id, String name) async {
    final db = await database;
    return await db.update('users', {'name': name}, where: 'id = ?', whereArgs: [id]);
  }

Future<List<Map<String, dynamic>>> getAllUsers() async {
  final db = await database;
  final res = await db.query('users');
  return res;
}
  
  // CARS
 
  Future<void> insertCars(List<Map<String, dynamic>> cars) async {
    final db = await database;
    for (var car in cars) {
      await db.insert('cars', car, conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<List<Map<String, dynamic>>> getAllCars() async {
    final db = await database;
    return await db.query('cars');
  }

  Future<Map<String, dynamic>?> getCarById(int id) async {
    final db = await database;
    final res = await db.query('cars', where: 'id = ?', whereArgs: [id], limit: 1);
    return res.isNotEmpty ? res.first : null;
  }

 
  // ORDERS
  
  Future<int> insertOrder(Map<String, dynamic> order) async {
    final db = await database;
    return await db.insert('orders', order);
  }

  // PAYMENTS
 
  Future<int> insertPayment(Map<String, dynamic> payment) async {
    final db = await database;
    return await db.insert('payments', payment);
  }

  
  // RECEIPTS (STRUK)
 
  Future<int> insertReceipt(Map<String, dynamic> receipt) async {
    final db = await database;
    return await db.insert('receipts', receipt);
  }

  
  // FEEDBACK

  Future<int> insertFeedback(Map<String, dynamic> data) async {
    final db = await database;
    return await db.insert('feedbacks', data);
  }

  Future<List<Map<String, dynamic>>> getFeedbacks() async {
    final db = await database;
    final result = await db.query('feedbacks', orderBy: 'created_at DESC');
    print(result); // <-- ini untuk cek di console
    return result;
  }
  Future<List<Map<String, dynamic>>> getFeedbacksWithUser() async {
  final db = await database;
  final result = await db.rawQuery('''
    SELECT f.id, f.message, f.created_at, u.name 
    FROM feedbacks f
    LEFT JOIN users u ON f.user_id = u.id
    ORDER BY f.created_at DESC
  ''');
  return result;
}



  // HISTORY JOIN (user bookings)
 
  Future<List<Map<String, dynamic>>> getUserHistory(int userId) async {
    final db = await database;
    return await db.rawQuery('''
      SELECT 
        o.id AS order_id,
        o.car_id AS car_id,
        c.name AS car_name,
        c.image as car_image,
        o.start_date,
        o.end_date,
        o.pickup_time,
        o.status,
        p.method,
        p.amount,
        p.currency,
          r.created_at AS receipt_date,
          r.pdf_path
      FROM orders o
      LEFT JOIN cars c ON o.car_id = c.id
      LEFT JOIN payments p ON p.order_id = o.id
      LEFT JOIN receipts r ON r.order_id = o.id
      WHERE o.user_id = ?
        ORDER BY o.id DESC
    ''', [userId]);
  }

  
  // RESET ALL (DEBUG)
 
  Future<void> clearAll() async {
    final db = await database;
    await db.delete('users');
    await db.delete('cars');
    await db.delete('orders');
    await db.delete('payments');
    await db.delete('receipts');
    await db.delete('feedbacks');
  }

  Future getAllOrders() async {
     final db = await database;
  final res = await db.query('orders');
  log("📦 Semua data orders: $res");
  return res;
  }

  Future<List<Map<String, dynamic>>> getAllReceipts() async {
    final db = await database;
    final res = await db.query('receipts');
    log("📦 Semua data receipts: $res");
    return res;
  }

  Future getOrders() async {}
}

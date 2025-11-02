import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) {
        print('Notifikasi diklik: ${response.payload}');
      },
    );
  }

  static Future<void> showBlueWhiteNotification({
    String title = "📢 Info Tiba!",
    String body = "Cek sekarang, ada update terbaru untukmu!",
  }) async {
    // Warna biru tua untuk background, teks putih
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'blue_channel',
      'Blue White Notifications',
      channelDescription: 'Notifikasi tiba-tiba biru tua & teks putih',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'ticker',
      color: Color(0xFF0D47A1), // Biru tua
      ledColor: Colors.white,
      ledOnMs: 1000,
      ledOffMs: 500,
      enableLights: true,
    );

    const NotificationDetails platformDetails =
        NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformDetails,
      payload: 'blue_white_notif',
    );
  }
}

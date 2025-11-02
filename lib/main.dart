import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_rental_project/screens/splash_screen.dart';
import 'package:car_rental_project/screens/onboarding_screen.dart';
import 'package:car_rental_project/screens/login_screen.dart';
import 'package:car_rental_project/screens/home_screen.dart';
import 'package:car_rental_project/screens/feedback_screen.dart';
import 'package:car_rental_project/screens/nearby_screen.dart';
import 'package:car_rental_project/screens/profile_screen.dart';
import 'package:car_rental_project/screens/history_screen.dart';
import 'package:car_rental_project/services/notification_service.dart';
import 'package:car_rental_project/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Car Rent & Go App',
      debugShowCheckedModeBanner: false,
       theme: themeProvider.lightTheme,
  darkTheme: themeProvider.darkTheme,
  themeMode: themeProvider.themeMode,
     
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => const OnboardingScreen(),
        '/login': (context) => const LoginScreen(),
        '/main': (context) => const MainNav(),
      },
    );
  }
}

class MainNav extends StatefulWidget {
  const MainNav({Key? key}) : super(key: key);

  @override
  State<MainNav> createState() => _MainNavState();
}

class _MainNavState extends State<MainNav> {
  int idx = 0;
  final pages = [
    const HomeScreen(),
    const NearbyScreen(),
    const HistoryScreen(),
    const FeedbackScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Kirim notifikasi setelah 5 detik
    Future.delayed(const Duration(seconds: 5), () {
      NotificationService.showBlueWhiteNotification(
        title: "📢 Update Tiba!",
        body: "Selamat datang di Car Rent & Go, ada info terbaru untukmu.",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[idx],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: idx,
        onTap: (i) => setState(() => idx = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Nearby'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.feedback_outlined), label: 'Feedback'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ================================
// lib/main.dart - Entry point aplikasi
// ================================
import 'package:flutter/material.dart';
import 'routes.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(BilliardBookingApp());
}

class BilliardBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billiard Booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        primaryColor: Color(0xFF2E7D32),
        accentColor: Color(0xFF66BB6A),
        backgroundColor: Color(0xFFF1F8E9),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
      routes: AppRoutes.routes,
    );
  }
}

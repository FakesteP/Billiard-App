// ================================
// lib/constants.dart - Konstanta umum
// ================================
import 'dart:ui';

class AppConstants {
  // API Configuration
  static const String baseUrl = 'https://api.billiard-booking.com';
  static const String apiVersion = 'v1';
  
  // Colors
  static const Color primaryColor = Color(0xFF2E7D32);
  static const Color secondaryColor = Color(0xFF66BB6A);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color backgroundColor = Color(0xFFF1F8E9);
  static const Color cardColor = Color(0xFFFFFFFF);
  
  // Strings
  static const String appName = 'Billiard Booking';
  static const String loginTitle = 'Login';
  static const String registerTitle = 'Register';
  static const String adminDashboard = 'Admin Dashboard';
  static const String userDashboard = 'User Dashboard';
  
  // Point System
  static const int pointsPerHour = 10;
  static const int bonusWinPoints = 5;
}

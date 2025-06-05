import 'package:flutter/material.dart';

class ApiConstants {
  static const String baseUrl = 'http://localhost:5000'; // Replace with your API URL
  static const String login = '$baseUrl/auth/login';
  static const String register = '$baseUrl/auth/register';
  static const String tables = '$baseUrl/tables';
  static const String bookings = '$baseUrl/bookings';
  static const String users = '$baseUrl/users';
  static const String news = '$baseUrl/news';
}

class AppColors {
  static const Color primary = Color(0xFF2C3E50);
  static const Color secondary = Color(0xFFE74C3C);
  static const Color accent = Color(0xFF3498DB);
  static const Color background = Color(0xFFECF0F1);
  static const Color textDark = Color(0xFF2C3E50);
  static const Color textLight = Color(0xFFECF0F1);
}

class AppStrings {
  static const String appName = 'Billiard Booking';
}
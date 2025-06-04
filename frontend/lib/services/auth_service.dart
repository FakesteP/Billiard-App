
// ================================
// lib/services/auth_service.dart - Service Autentikasi
// ================================
import 'dart:convert';
// import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../constants.dart';

class AuthService {
  static UserModel? _currentUser;
  
  static UserModel? get currentUser => _currentUser;
  
  // Mock login - ganti dengan API call sesungguhnya
  static Future<bool> login(String email, String password) async {
    try {
      // Simulasi API call
      await Future.delayed(Duration(seconds: 2));
      
      // Mock data - ganti dengan response API
      if (email == 'admin@billiard.com' && password == 'admin123') {
        _currentUser = UserModel(
          id: '1',
          name: 'Admin',
          email: email,
          phone: '081234567890',
          role: UserRole.admin,
          createdAt: DateTime.now(),
        );
        return true;
      } else if (email == 'user@billiard.com' && password == 'user123') {
        _currentUser = UserModel(
          id: '2',
          name: 'John Doe',
          email: email,
          phone: '081234567891',
          role: UserRole.user,
          points: 150,
          createdAt: DateTime.now(),
        );
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
  
  static Future<bool> register(String name, String email, String phone, String password) async {
    try {
      // Simulasi API call
      await Future.delayed(Duration(seconds: 2));
      
      // Mock success - ganti dengan API call sesungguhnya
      return true;
    } catch (e) {
      return false;
    }
  }
  
  static void logout() {
    _currentUser = null;
  }
  
  static bool get isLoggedIn => _currentUser != null;
  static bool get isAdmin => _currentUser?.role == UserRole.admin;
}


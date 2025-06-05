import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService with ChangeNotifier {
  UserModel? _user;
  bool _isAuthenticated = false;
  String? errorMessage; // Tambahkan ini

  UserModel? get user => _user;
  bool get isAuthenticated => _isAuthenticated;
  String? _role;
  String? get role => _role;

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        body: json.encode({
          'email': email,
          'password': password,
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['token']);
          // Decode JWT untuk ambil role
          Map<String, dynamic> decodedToken = JwtDecoder.decode(data['token']);
          _role = decodedToken['role'];
          await prefs.setString('role', _role ?? '');
          _isAuthenticated = true;
          errorMessage = null;
        } else {
          errorMessage = 'Invalid response from server. Please contact admin.';
          _isAuthenticated = false;
        }
        notifyListeners();
      } else {
        print('Login failed: ${response.body}');
        final data = json.decode(response.body);
        errorMessage = data['message'] ?? 'Login failed';
        _isAuthenticated = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Login failed. Please try again.';
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> register(String username, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.register),
        body: json.encode({
          'username': username,
          'email': email,
          'password': password,
          'role': 'customer',
        }),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        errorMessage = null;
        notifyListeners();
      } else {
        print('Register failed: ${response.body}');
        final data = json.decode(response.body);
        errorMessage = data['message'] ?? 'Registration failed';
        if (data['errors'] != null && data['errors'] is List) {
          final errors = (data['errors'] as List)
              .map((e) => e['message'] ?? e.toString())
              .join('\n');
          errorMessage = '$errorMessage\n$errors';
        }
        _isAuthenticated = false;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Registration failed. Please try again.';
      _isAuthenticated = false;
      notifyListeners();
    }
  }

  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    _role = prefs.getString('role');
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('role');
    _user = null;
    _isAuthenticated = false;
    _role = null;
    notifyListeners();
  }
}

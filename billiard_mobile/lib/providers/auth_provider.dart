import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _role;
  int? _userId;
  String? _errorMessage;
  String? _email;
  String? _username;
  String? get token => _token;
  String? get role => _role;
  int? get userId => _userId;
  String? get errorMessage => _errorMessage;
  String? get email => _email;
  String? get username => _username;

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/auth/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        // Cek role di root dan di dalam user
        _role = data['role'] ?? data['user']?['role'];
        _userId = data['id'] ?? data['user']?['id'];
        _email = data['email'] ?? data['user']?['email'];
        _username = data['username'] ?? data['user']?['username'];
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Login gagal';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan';
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String username, String email, String password, String role) async {
    final url = Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/auth/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Registrasi gagal';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan';
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _token = null;
    _role = null;
    notifyListeners();
  }
}

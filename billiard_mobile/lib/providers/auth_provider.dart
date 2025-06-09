import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _role;
  int? _userId;
  String? _errorMessage;
  String? _email;
  String? _username;
  bool _isInitialized = false;

  String? get token => _token;
  String? get role => _role;
  int? get userId => _userId;
  String? get errorMessage => _errorMessage;
  String? get email => _email;
  String? get username => _username;
  bool get isInitialized => _isInitialized;
  bool get isLoggedIn => _token != null; // Initialize and load saved session
  Future<void> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      _role = prefs.getString('auth_role');
      _userId = prefs.getInt('auth_user_id');
      _email = prefs.getString('auth_email');
      _username = prefs.getString('auth_username');

      print(
          'DEBUG: Loaded session - Token: ${_token != null ? 'exists' : 'null'}, Role: $_role, Username: $_username');

      // Validate token if it exists
      if (_token != null) {
        bool isValid = await validateToken();
        if (!isValid) {
          print('DEBUG: Token validation failed, clearing session');
          await _clearSession();
        }
      }

      // Debug: Print all session data
      await debugPrintSavedSession();

      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      print('DEBUG: Error loading session: $e');
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Save session data to SharedPreferences
  Future<void> _saveSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_token != null) {
        await prefs.setString('auth_token', _token!);
        print('DEBUG: Saved token to SharedPreferences');
      }
      if (_role != null) {
        await prefs.setString('auth_role', _role!);
        print('DEBUG: Saved role: $_role');
      }
      if (_userId != null) {
        await prefs.setInt('auth_user_id', _userId!);
        print('DEBUG: Saved userId: $_userId');
      }
      if (_email != null) {
        await prefs.setString('auth_email', _email!);
        print('DEBUG: Saved email: $_email');
      }
      if (_username != null) {
        await prefs.setString('auth_username', _username!);
        print('DEBUG: Saved username: $_username');
      }

      // Verify the save by reading back
      final savedToken = prefs.getString('auth_token');
      print(
          'DEBUG: Verification - Token saved: ${savedToken != null ? 'exists' : 'null'}');
    } catch (e) {
      print('DEBUG: Error saving session: $e');
    }
  }

  // Clear session data from SharedPreferences
  Future<void> _clearSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('auth_role');
      await prefs.remove('auth_user_id');
      await prefs.remove('auth_email');
      await prefs.remove('auth_username');
      print('DEBUG: Session cleared from SharedPreferences');
    } catch (e) {
      print('DEBUG: Error clearing session: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      print('DEBUG: Login attempt for email: $email');
      final response = await ApiService.post(
        '/auth/login',
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        _role = data['role'] ?? data['user']?['role'];
        _userId = data['id'] ?? data['user']?['id'];
        _email = data['email'] ?? data['user']?['email'];
        _username = data['username'] ?? data['user']?['username'];
        _errorMessage = null;

        print(
            'DEBUG: Login successful - Token: ${_token != null ? 'exists' : 'null'}, Role: $_role, Username: $_username'); // Save session to SharedPreferences
        await _saveSession();

        // Debug: Print session after saving
        await debugPrintSavedSession();

        notifyListeners();
        return true;
      } else {
        final data = jsonDecode(response.body);
        _errorMessage = data['message'] ?? 'Login gagal';
        print(
            'DEBUG: Login failed - Status: ${response.statusCode}, Message: $_errorMessage');
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan';
      print('DEBUG: Login error: $e');
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(
      String username, String email, String password, String role) async {
    try {
      final response = await ApiService.post(
        '/auth/register',
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

  Future<void> logout() async {
    print('DEBUG: Logout called');
    _token = null;
    _role = null;
    _userId = null;
    _email = null;
    _username = null;
    _errorMessage = null;

    // Clear session from SharedPreferences
    await _clearSession();

    print('DEBUG: Logout completed');
    notifyListeners();
  } // Validate token by making a test API call

  Future<bool> validateToken() async {
    if (_token == null) return false;

    try {
      print('DEBUG: Validating token with /auth/profile endpoint');
      final response = await ApiService.get(
        '/auth/profile',
        headers: {'Authorization': 'Bearer $_token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(
            'DEBUG: Token validation successful - User: ${data['user']?['username']}');

        // Update user data from profile response if needed
        if (data['user'] != null) {
          _email = data['user']['email'] ?? _email;
          _username = data['user']['username'] ?? _username;
          _role = data['user']['role'] ?? _role;
          _userId = data['user']['id'] ?? _userId;
        }

        return true;
      } else {
        print(
            'DEBUG: Token validation failed - Status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('DEBUG: Token validation error: $e');
      // Network error or other issues, assume token is still valid for offline functionality
      return true;
    }
  }

  // Check session and validate token on app start
  Future<void> checkSession() async {
    if (_token != null) {
      final isValid = await validateToken();
      if (!isValid) {
        _token = null;
        _role = null;
        _userId = null;
        _email = null;
        _username = null;
        await _clearSession();
        notifyListeners();
      }
    }
  }

  // Refresh token if the backend supports it
  Future<bool> refreshToken() async {
    if (_token == null) return false;

    // TODO: Backend doesn't have refresh endpoint yet
    // For now, just assume refresh is successful
    print('DEBUG: Token refresh skipped - assuming valid token');
    return true;

    /* Commented out until backend has proper refresh endpoint
    try {
      final response = await ApiService.post(
        '/auth/refresh',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_token'
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];
        await _saveSession();
        notifyListeners();
        return true;
      } else {
        // Refresh failed, clear session
        logout();
        return false;
      }
    } catch (e) {
      // Refresh failed, clear session
      logout();
      return false;
    }
    */
  }

  // Debug method to print all saved session data
  Future<void> debugPrintSavedSession() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final keys = prefs.getKeys();
      print('DEBUG: All SharedPreferences keys: $keys');

      final token = prefs.getString('auth_token');
      final role = prefs.getString('auth_role');
      final userId = prefs.getInt('auth_user_id');
      final email = prefs.getString('auth_email');
      final username = prefs.getString('auth_username');

      print('DEBUG: Current session data:');
      print(
          '  Token: ${token != null ? 'exists (${token.length} chars)' : 'null'}');
      print('  Role: $role');
      print('  UserId: $userId');
      print('  Email: $email');
      print('  Username: $username');
    } catch (e) {
      print('DEBUG: Error reading session data: $e');
    }
  }
}

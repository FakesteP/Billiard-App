import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class StatisticsService {
  static const Duration _timeout = Duration(seconds: 10);

  // Get dashboard statistics (public)
  static Future<Map<String, dynamic>?> getDashboardStats() async {
    try {
      final response =
          await ApiService.get('/statistics/dashboard').timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Validate the response structure
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          print('Invalid dashboard stats response format');
          return null;
        }
      } else {
        print(
            'Failed to get dashboard stats: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on TimeoutException {
      print('Timeout getting dashboard stats');
      return null;
    } catch (e) {
      print('Error getting dashboard stats: $e');
      return null;
    }
  }

  // Get user-specific statistics (protected)
  static Future<Map<String, dynamic>?> getUserStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        print('No auth token found for user stats');
        return null;
      }

      final response = await ApiService.get(
        '/statistics/user',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          print('Invalid user stats response format');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized access to user stats - token may be expired');
        return null;
      } else {
        print(
            'Failed to get user stats: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on TimeoutException {
      print('Timeout getting user stats');
      return null;
    } catch (e) {
      print('Error getting user stats: $e');
      return null;
    }
  }

  // Get available tables statistics (public)
  static Future<Map<String, dynamic>?> getAvailableTablesStats() async {
    try {
      final response =
          await ApiService.get('/statistics/tables').timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          print('Invalid tables stats response format');
          return null;
        }
      } else {
        print(
            'Failed to get tables stats: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on TimeoutException {
      print('Timeout getting tables stats');
      return null;
    } catch (e) {
      print('Error getting tables stats: $e');
      return null;
    }
  }

  // Get admin activities (protected - admin only)
  static Future<Map<String, dynamic>?> getAdminActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        print('No auth token found for admin activities');
        return null;
      }

      final response = await ApiService.get(
        '/statistics/admin/activities',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          print('Invalid admin activities response format');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized access to admin activities');
        return null;
      } else {
        print(
            'Failed to get admin activities: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on TimeoutException {
      print('Timeout getting admin activities');
      return null;
    } catch (e) {
      print('Error getting admin activities: $e');
      return null;
    }
  }

  // Get user activities (protected)
  static Future<Map<String, dynamic>?> getUserActivities() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token.isEmpty) {
        print('No auth token found for user activities');
        return null;
      }

      final response = await ApiService.get(
        '/statistics/user/activities',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(_timeout);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic>) {
          return data;
        } else {
          print('Invalid user activities response format');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Unauthorized access to user activities');
        return null;
      } else {
        print(
            'Failed to get user activities: ${response.statusCode} - ${response.body}');
        return null;
      }
    } on TimeoutException {
      print('Timeout getting user activities');
      return null;
    } catch (e) {
      print('Error getting user activities: $e');
      return null;
    }
  }
}

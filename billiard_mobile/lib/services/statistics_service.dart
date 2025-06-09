import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';

class StatisticsService {
  // Get dashboard statistics (public)
  static Future<Map<String, dynamic>?> getDashboardStats() async {
    try {
      final response = await ApiService.get('/statistics/dashboard');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get dashboard stats: ${response.statusCode}');
        return null;
      }
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
      
      if (token == null) {
        print('No auth token found');
        return null;
      }

      final response = await ApiService.get(
        '/statistics/user',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get user stats: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting user stats: $e');
      return null;
    }
  }

  // Get available tables statistics (public)
  static Future<Map<String, dynamic>?> getAvailableTablesStats() async {
    try {
      final response = await ApiService.get('/statistics/tables');
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Failed to get tables stats: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting tables stats: $e');
      return null;
    }
  }
}

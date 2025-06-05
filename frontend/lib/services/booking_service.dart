import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/booking_model.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class BookingService with ChangeNotifier {
  List<BookingModel> _bookings = [];
  List<BookingModel> _userBookings = [];
  bool _isLoading = false;

  List<BookingModel> get bookings => _bookings;
  List<BookingModel> get userBookings => _userBookings;
  bool get isLoading => _isLoading;

  Future<void> fetchBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(ApiConstants.bookings),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _bookings = data.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserBookings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Ganti endpoint ke /bookings (tanpa /me)
      final response = await http.get(
        Uri.parse(ApiConstants.bookings),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _userBookings =
            data.map((json) => BookingModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load user bookings');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBooking({
    required String tableId,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      int? userId;
      if (token != null) {
        final decoded = JwtDecoder.decode(token);
        userId = decoded['id'];
      }

      final response = await http.post(
        Uri.parse(ApiConstants.bookings),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'user_id': userId,
          'table_id': int.tryParse(tableId) ?? tableId,
          'date': date,
          'start_time': startTime,
          'end_time': endTime,
          'status': 'pending', // Set status pending saat booking baru
        }),
      );

      if (response.statusCode == 201) {
        await fetchUserBookings();
      } else if (response.statusCode == 409) {
        throw Exception('409');
      } else {
        throw Exception('Failed to create booking');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      // Gunakan endpoint PUT /bookings/:id sesuai request.rest
      final response = await http.put(
        Uri.parse('${ApiConstants.bookings}/$bookingId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': status}),
      );

      if (response.statusCode == 200) {
        await fetchBookings();
      } else {
        throw Exception('Failed to update booking status');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> cancelBooking(String bookingId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.patch(
        Uri.parse('${ApiConstants.bookings}/$bookingId/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({'status': 'cancelled'}),
      );

      if (response.statusCode == 200) {
        await fetchUserBookings();
      } else {
        throw Exception('Failed to cancel booking');
      }
    } catch (e) {
      rethrow;
    }
  }
}

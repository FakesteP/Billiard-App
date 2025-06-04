// ================================
// lib/services/booking_service.dart - Service Booking
// ================================
import '../models/booking_model.dart';
import 'auth_service.dart';

class BookingService {
  static List<BookingModel> _bookings = [
    BookingModel(
      id: '1',
      userId: '2',
      tableId: '1',
      bookingDate: DateTime.now(),
      startTime: DateTime.now().add(Duration(hours: 1)),
      endTime: DateTime.now().add(Duration(hours: 3)),
      status: BookingStatus.confirmed,
      totalPrice: 100000,
      createdAt: DateTime.now(),
    ),
  ];
  
  static Future<List<BookingModel>> getAllBookings() async {
    await Future.delayed(Duration(seconds: 1));
    return _bookings;
  }
  
  static Future<List<BookingModel>> getUserBookings(String userId) async {
    await Future.delayed(Duration(seconds: 1));
    return _bookings.where((booking) => booking.userId == userId).toList();
  }
  
  static Future<bool> createBooking(BookingModel booking) async {
    await Future.delayed(Duration(seconds: 1));
    _bookings.add(booking);
    return true;
  }
  
  static Future<bool> updateBookingStatus(String bookingId, BookingStatus status) async {
    await Future.delayed(Duration(seconds: 1));
    int index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      BookingModel oldBooking = _bookings[index];
      _bookings[index] = BookingModel(
        id: oldBooking.id,
        userId: oldBooking.userId,
        tableId: oldBooking.tableId,
        bookingDate: oldBooking.bookingDate,
        startTime: oldBooking.startTime,
        endTime: oldBooking.endTime,
        status: status,
        totalPrice: oldBooking.totalPrice,
        player1Score: oldBooking.player1Score,
        player2Score: oldBooking.player2Score,
        winnerId: oldBooking.winnerId,
        pointsEarned: oldBooking.pointsEarned,
        createdAt: oldBooking.createdAt,
      );
      return true;
    }
    return false;
  }
  
  static Future<bool> updateGameResult(String bookingId, int player1Score, int player2Score, String? winnerId) async {
    await Future.delayed(Duration(seconds: 1));
    int index = _bookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      BookingModel oldBooking = _bookings[index];
      int pointsEarned = _calculatePoints(oldBooking.duration, winnerId == oldBooking.userId);
      
      _bookings[index] = BookingModel(
        id: oldBooking.id,
        userId: oldBooking.userId,
        tableId: oldBooking.tableId,
        bookingDate: oldBooking.bookingDate,
        startTime: oldBooking.startTime,
        endTime: oldBooking.endTime,
        status: BookingStatus.completed,
        totalPrice: oldBooking.totalPrice,
        player1Score: player1Score,
        player2Score: player2Score,
        winnerId: winnerId,
        pointsEarned: pointsEarned,
        createdAt: oldBooking.createdAt,
      );
      return true;
    }
    return false;
  }
  
  static int _calculatePoints(Duration duration, bool isWinner) {
    int basePoints = (duration.inHours * AppConstants.pointsPerHour).round();
    return isWinner ? basePoints + AppConstants.bonusWinPoints : basePoints;
  }
}


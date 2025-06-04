// ================================
// lib/models/booking_model.dart - Model Booking
// ================================
class BookingModel {
  final String id;
  final String userId;
  final String tableId;
  final DateTime bookingDate;
  final DateTime startTime;
  final DateTime endTime;
  final BookingStatus status;
  final double totalPrice;
  final int? player1Score;
  final int? player2Score;
  final String? winnerId;
  final int pointsEarned;
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.tableId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.totalPrice,
    this.player1Score,
    this.player2Score,
    this.winnerId,
    this.pointsEarned = 0,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      userId: json['user_id'],
      tableId: json['table_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      status: BookingStatus.values.firstWhere((e) => e.toString() == 'BookingStatus.${json['status']}'),
      totalPrice: json['total_price'].toDouble(),
      player1Score: json['player1_score'],
      player2Score: json['player2_score'],
      winnerId: json['winner_id'],
      pointsEarned: json['points_earned'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'table_id': tableId,
      'booking_date': bookingDate.toIso8601String(),
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'status': status.toString().split('.').last,
      'total_price': totalPrice,
      'player1_score': player1Score,
      'player2_score': player2Score,
      'winner_id': winnerId,
      'points_earned': pointsEarned,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Duration get duration => endTime.difference(startTime);
}

enum BookingStatus { pending, confirmed, playing, completed, cancelled }


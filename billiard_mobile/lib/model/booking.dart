class Booking {
  final int id;
  final int userId;
  final int tableId;
  final DateTime date;

  Booking({
    required this.id,
    required this.userId,
    required this.tableId,
    required this.date,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        id: json['id'],
        userId: json['user_id'],
        tableId: json['table_id'],
        date: DateTime.parse(json['date']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'table_id': tableId,
        'date': date.toIso8601String(),
      };
}

class BookingModel {
  final String id;
  final String userId;
  final String userName;
  final String tableId;
  final String tableName;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final String createdAt;
  final String updatedAt;

  BookingModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.tableId,
    required this.tableName,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'].toString(),
      userId: json['userId']?.toString() ?? json['user_id']?.toString() ?? '',
      userName: json['userName'] ?? json['user_name'] ?? '',
      tableId:
          json['tableId']?.toString() ?? json['table_id']?.toString() ?? '',
      tableName: json['tableName'] ?? json['table_name'] ?? '',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? json['start_time'] ?? '',
      endTime: json['endTime'] ?? json['end_time'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['createdAt'] ?? json['created_at'] ?? '',
      updatedAt: json['updatedAt'] ?? json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'tableId': tableId,
      'date': date,
      'startTime': startTime,
      'endTime': endTime,
      'status': status,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

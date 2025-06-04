
// ================================
// lib/models/user_model.dart - Model User
// ================================
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final UserRole role;
  final int points;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
    this.points = 0,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      role: UserRole.values.firstWhere((e) => e.toString() == 'UserRole.${json['role']}'),
      points: json['points'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'points': points,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

enum UserRole { admin, user }


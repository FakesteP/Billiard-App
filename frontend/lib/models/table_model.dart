class TableModel {
  final String id;
  final String name;
  final String status;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;

  TableModel({
    required this.id,
    required this.name,
    required this.status,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'].toString(),
      name: json['name'],
      status: json['status'],
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'image_url': imageUrl,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}

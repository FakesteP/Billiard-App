class TableModel {
  final int id;
  final String name;
  final bool isAvailable;
  final String? imageUrl;

  TableModel({
    required this.id,
    required this.name,
    required this.isAvailable,
    this.imageUrl,
  });

  factory TableModel.fromJson(Map<String, dynamic> json) => TableModel(
        id: json['id'],
        name: json['name'] ?? '',
        isAvailable: (json['status'] ?? '') == 'available',
        imageUrl: json['image_url'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': isAvailable ? 'available' : 'booked',
        'image_url': imageUrl,
      };
}

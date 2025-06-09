class TableModel {
  final int id;
  final String name;
  final bool isAvailable;
  // ...tambahkan field lain sesuai kebutuhan...

  TableModel({
    required this.id,
    required this.name,
    required this.isAvailable,
    // ...field lain...
  });

  // ...tambahkan fromJson, toJson, dll jika perlu...
}

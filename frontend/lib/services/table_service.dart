// ================================
// lib/services/table_service.dart - Service Meja
// ================================
import '../models/table_model.dart';

class TableService {
  // Mock data - ganti dengan API call
  static List<TableModel> _tables = [
    TableModel(
      id: '1',
      name: 'Meja VIP 1',
      description: 'Meja bilyar premium dengan pencahayaan terbaik',
      imageUrl: 'https://example.com/table1.jpg',
      status: TableStatus.available,
      pricePerHour: 50000,
      createdAt: DateTime.now().subtract(Duration(days: 30)),
      updatedAt: DateTime.now(),
    ),
    TableModel(
      id: '2',
      name: 'Meja Reguler 1',
      description: 'Meja bilyar standar untuk permainan casual',
      imageUrl: 'https://example.com/table2.jpg',
      status: TableStatus.booked,
      pricePerHour: 30000,
      createdAt: DateTime.now().subtract(Duration(days: 25)),
      updatedAt: DateTime.now(),
    ),
  ];
  
  static Future<List<TableModel>> getAllTables() async {
    await Future.delayed(Duration(seconds: 1));
    return _tables;
  }
  
  static Future<List<TableModel>> getAvailableTables() async {
    await Future.delayed(Duration(seconds: 1));
    return _tables.where((table) => table.status == TableStatus.available).toList();
  }
  
  static Future<bool> addTable(TableModel table) async {
    await Future.delayed(Duration(seconds: 1));
    _tables.add(table);
    return true;
  }
  
  static Future<bool> updateTable(TableModel table) async {
    await Future.delayed(Duration(seconds: 1));
    int index = _tables.indexWhere((t) => t.id == table.id);
    if (index != -1) {
      _tables[index] = table;
      return true;
    }
    return false;
  }
  
  static Future<bool> deleteTable(String tableId) async {
    await Future.delayed(Duration(seconds: 1));
    _tables.removeWhere((table) => table.id == tableId);
    return true;
  }
}


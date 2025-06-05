import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/table_model.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TableService with ChangeNotifier {
  List<TableModel> _tables = [];
  bool _isLoading = false;

  List<TableModel> get tables => _tables;
  bool get isLoading => _isLoading;

  Future<void> fetchTables() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.get(
        Uri.parse(ApiConstants.tables),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _tables = data.map((json) => TableModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load tables');
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTable(TableModel table) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.post(
        Uri.parse(ApiConstants.tables),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(table.toJson()),
      );

      if (response.statusCode == 201) {
        await fetchTables();
      } else {
        throw Exception('Failed to add table');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTable(TableModel table) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.put(
        Uri.parse('${ApiConstants.tables}/${table.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(table.toJson()),
      );

      if (response.statusCode == 200) {
        await fetchTables();
      } else {
        throw Exception('Failed to update table');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTable(String tableId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      final response = await http.delete(
        Uri.parse('${ApiConstants.tables}/$tableId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await fetchTables();
      } else {
        throw Exception('Failed to delete table');
      }
    } catch (e) {
      rethrow;
    }
  }
}

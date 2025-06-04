// ================================
// lib/screens/admin/table_list_screen.dart - List Meja Admin
// ================================
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../routes.dart';
import '../../models/table_model.dart';
import '../../services/table_service.dart';

class TableListScreen extends StatefulWidget {
  @override
  _TableListScreenState createState() => _TableListScreenState();
}

class _TableListScreenState extends State<TableListScreen> {
  List<TableModel> _tables = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  _loadTables() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<TableModel> tables = await TableService.getAllTables();
      setState(() {
        _tables = tables;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data meja')),
      );
    }
  }

  _deleteTable(String tableId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Konfirmasi'),
        content: Text('Apakah Anda yakin ingin menghapus meja ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      bool success = await TableService.deleteTable(tableId);
      if (success) {
        _loadTables();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Meja berhasil dihapus')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text('Manajemen Meja'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.tableForm).then((_) {
                _loadTables();
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _tables.length,
              itemBuilder: (context, index) {
                TableModel table = _tables[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getStatusColor(table.status),
                      child: Icon(
                        Icons.table_restaurant,
                        color: Colors.white,
                      ),
                    ),
                    title: Text(
                      table.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(table.description),
                        Text(
                          'Rp ${table.pricePerHour.toStringAsFixed(0)}/jam',
                          style: TextStyle(
                            color: AppConstants.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Chip(
                          label: Text(
                            _getStatusText(table.status),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          backgroundColor: _getStatusColor(table.status),
                        ),
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Hapus', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 'edit') {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.tableForm,
                                arguments: table,
                              ).then((_) {
                                _loadTables();
                              });
                            } else if (value == 'delete') {
                              _deleteTable(table.id);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green;
      case TableStatus.booked:
        return Colors.orange;
      case TableStatus.maintenance:
        return Colors.red;
    }
  }

  String _getStatusText(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return 'Tersedia';
      case TableStatus.booked:
        return 'Sedang Digunakan';
      case TableStatus.maintenance:
        return 'Maintenance';
    }
  }
}
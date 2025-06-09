import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import 'table_form_page.dart';
import 'booking_form_page.dart';

class TableListPage extends StatefulWidget {
  const TableListPage({Key? key}) : super(key: key);

  @override
  State<TableListPage> createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
  List tables = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchTables() async {
    setState(() { isLoading = true; errorMessage = null; });
    try {
      final response = await http.get(
        Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/tables'),
      );
      if (response.statusCode == 200) {
        tables = jsonDecode(response.body);
      } else {
        errorMessage = 'Gagal memuat data meja';
      }
    } catch (e) {
      errorMessage = 'Terjadi kesalahan';
    }
    setState(() { isLoading = false; });
  }

  @override
  void initState() {
    super.initState();
    fetchTables();
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<AuthProvider>(context, listen: false).role;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Meja'),
        actions: [
          if (role == 'admin')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TableFormPage()),
                );
                if (result == true) fetchTables();
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: tables.length,
                  itemBuilder: (context, index) {
                    final table = tables[index];
                    return Card(
                      child: ListTile(
                        leading: table['image_url'] != null
                            ? Image.network(table['image_url'], width: 60, height: 60, fit: BoxFit.cover)
                            : const Icon(Icons.table_bar),
                        title: Text(table['name'] ?? '-'),
                        subtitle: Text('Status: ${table['status']}'),
                        trailing: role == 'admin'
                            ? PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TableFormPage(table: table),
                                      ),
                                    );
                                    if (result == true) fetchTables();
                                  } else if (value == 'delete') {
                                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                                    final token = authProvider.token;
                                    final url = Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/tables/${table['id']}');
                                    try {
                                      final response = await http.delete(
                                        url,
                                        headers: {'Authorization': 'Bearer $token'},
                                      );
                                      if (response.statusCode == 200) {
                                        fetchTables();
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('Gagal menghapus meja')),
                                        );
                                      }
                                    } catch (e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('Terjadi kesalahan')),
                                      );
                                    }
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                                ],
                              )
                            : null,
                        onTap: role == 'customer'
                            ? () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BookingFormPage(tableId: table['id']),
                                  ),
                                );
                                if (result == true) fetchTables();
                              }
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}

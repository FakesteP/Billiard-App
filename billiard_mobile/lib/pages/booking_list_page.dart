import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({Key? key}) : super(key: key);

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  List bookings = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchBookings() async {
    setState(() { isLoading = true; errorMessage = null; });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final role = authProvider.role;
    final userId = authProvider.userId;
    try {
      final response = await http.get(
        Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/bookings'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        bookings = role == 'customer'
            ? data.where((b) => b['user_id'] == userId).toList()
            : data;
      } else {
        errorMessage = 'Gagal memuat data booking';
      }
    } catch (e) {
      errorMessage = 'Terjadi kesalahan';
    }
    setState(() { isLoading = false; });
  }

  Future<void> updateStatus(int id, String status) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    try {
      final response = await http.put(
        Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/bookings/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );
      if (response.statusCode == 200) {
        fetchBookings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update status')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan')),
      );
    }
  }

  Future<void> deleteBooking(int id) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    try {
      final response = await http.delete(
        Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/bookings/$id'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        fetchBookings();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus booking')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<AuthProvider>(context, listen: false).role;
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Booking')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      child: ListTile(
                        title: Text('Meja: ${booking['table_id']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tanggal: ${booking['date']}'),
                            Text('Jam: ${booking['start_time']} - ${booking['end_time']}'),
                            Text('Status: ${booking['status']}'),
                          ],
                        ),
                        trailing: role == 'admin'
                            ? PopupMenuButton<String>(
                                onSelected: (value) {
                                  if (value == 'completed') {
                                    updateStatus(booking['id'], 'completed');
                                  } else if (value == 'delete') {
                                    deleteBooking(booking['id']);
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'completed', child: Text('Set Completed')),
                                  const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                                ],
                              )
                            : null,
                      ),
                    );
                  },
                ),
    );
  }
}

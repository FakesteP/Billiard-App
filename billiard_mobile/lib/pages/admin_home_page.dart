import 'package:flutter/material.dart';
import 'table_list_page.dart';
import 'booking_list_page.dart';
import 'user_list_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.table_bar),
            title: const Text('Kelola Meja'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TableListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Kelola Booking'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookingListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Lihat User'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UserListPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

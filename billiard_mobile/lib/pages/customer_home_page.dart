import 'package:flutter/material.dart';
import 'table_list_page.dart';
import 'booking_list_page.dart';
import 'profile_page.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Dashboard')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.table_bar),
            title: const Text('Lihat Meja'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TableListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.list_alt),
            title: const Text('Booking Saya'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookingListPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Profil'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
    );
  }
}

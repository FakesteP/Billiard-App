import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'table_list_page.dart';
import 'booking_list_page.dart';
import 'user_list_page.dart';
import 'login_page.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus hanya token
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card untuk Kelola Meja
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Icon(Icons.table_bar,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text('Kelola Meja'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TableListPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Card untuk Kelola Booking
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Icon(Icons.list_alt,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text('Kelola Booking'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BookingListPage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Card untuk Lihat User
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Theme.of(context).cardColor,
              child: ListTile(
                leading: Icon(Icons.people,
                    color: Theme.of(context).colorScheme.primary),
                title: const Text('Lihat User'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserListPage()),
                  );
                },
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Logout'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(48),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          ),
          onPressed: () async {
            await _logout(context);
          },
        ),
      ),
    );
  }
}

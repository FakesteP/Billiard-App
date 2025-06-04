// ================================
// lib/screens/admin/admin_home_screen.dart - Dashboard Admin
// ================================
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';

class AdminHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(AppConstants.adminDashboard),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Selamat datang, ${AuthService.currentUser?.name}!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.primaryColor,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildMenuCard(
                    context,
                    'Manajemen Meja',
                    Icons.table_restaurant,
                    'Kelola meja bilyar',
                    AppRoutes.adminTables,
                  ),
                  _buildMenuCard(
                    context,
                    'Daftar Booking',
                    Icons.book_online,
                    'Kelola booking user',
                    AppRoutes.adminBookings,
                  ),
                  _buildMenuCard(
                    context,
                    'Tambah Meja',
                    Icons.add_box,
                    'Tambah meja baru',
                    AppRoutes.tableForm,
                  ),
                  _buildMenuCard(
                    context,
                    'Statistik',
                    Icons.analytics,
                    'Lihat statistik',
                    null, // TODO: Implement statistics
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, IconData icon, String subtitle, String? route) {
    return Card(
      elevation: 4,
      child: InkWell(
        onTap: route != null ? () => Navigator.pushNamed(context, route) : null,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: AppConstants.primaryColor,
              ),
              SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

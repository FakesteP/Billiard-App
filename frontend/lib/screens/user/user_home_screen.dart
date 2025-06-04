// ================================
// lib/screens/user/user_home_screen.dart - Dashboard User
// ================================
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../routes.dart';
import '../../services/auth_service.dart';

class UserHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text('Dashboard User'),
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
            SizedBox(height: 8),
            Text(
              'Siap bermain bilyar hari ini?',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
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
                    'Pilih Meja',
                    Icons.table_restaurant,
                    'Lihat & booking meja',
                    AppRoutes.userTables,
                  ),
                  _buildMenuCard(
                    context,
                    'Booking Saya',
                    Icons.book_online,
                    'Riwayat booking',
                    AppRoutes.userBookings,
                  ),
                  _buildMenuCard(
                    context,
                    'Leaderboard',
                    Icons.emoji_events,
                    'Top player bilyar',
                    AppRoutes.leaderboard,
                  ),
                  _buildMenuCard(
                    context,
                    'Profil',
                    Icons.person,
                    'Edit profil saya',
                    AppRoutes.profile,
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
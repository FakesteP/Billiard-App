
// ================================
// lib/routes.dart - Daftar rute navigasi
// ================================
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/table_list_screen.dart' as admin;
import 'screens/admin/booking_list_screen.dart' as admin;
import 'screens/admin/table_form_screen.dart';
import 'screens/user/user_home_screen.dart';
import 'screens/user/table_list_screen.dart' as user;
import 'screens/user/booking_list_screen.dart' as user;
import 'screens/user/leaderboard_screen.dart';
import 'screens/user/news_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String adminHome = '/admin-home';
  static const String adminTables = '/admin-tables';
  static const String adminBookings = '/admin-bookings';
  static const String tableForm = '/table-form';
  static const String userHome = '/user-home';
  static const String userTables = '/user-tables';
  static const String userBookings = '/user-bookings';
  static const String leaderboard = '/leaderboard';
  static const String news = '/news';

  static Map<String, WidgetBuilder> routes = {
    splash: (context) => SplashScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    adminHome: (context) => AdminHomeScreen(),
    adminTables: (context) => admin.TableListScreen(),
    adminBookings: (context) => admin.BookingListScreen(),
    tableForm: (context) => TableFormScreen(),
    userHome: (context) => UserHomeScreen(),
    userTables: (context) => user.TableListScreen(),
    userBookings: (context) => user.BookingListScreen(),
    leaderboard: (context) => LeaderboardScreen(),
    news: (context) => NewsScreen(),
  };
}

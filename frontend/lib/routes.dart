import 'package:flutter/material.dart';
import 'models/table_model.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/admin/admin_home_screen.dart';
import 'screens/admin/table_list_screen.dart';
import 'screens/admin/booking_list_screen.dart';
import 'screens/admin/table_form_screen.dart';
import 'screens/user/user_home_screen.dart';
import 'screens/user/table_list_screen.dart' as user_table;
import 'screens/user/booking_list_screen.dart' as user_booking;
import 'screens/user/news_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/splash':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case '/admin/home':
        return MaterialPageRoute(builder: (_) => const AdminHomeScreen());
      case '/admin/tables':
        return MaterialPageRoute(builder: (_) => const TableListScreen());
      case '/admin/tables/form':
        return MaterialPageRoute(
          builder: (_) => TableFormScreen(
            table: settings.arguments as TableModel?,
          ),
        );
      case '/admin/bookings':
        return MaterialPageRoute(builder: (_) => const BookingListScreen());
      case '/user/home':
        return MaterialPageRoute(builder: (_) => const UserHomeScreen());
      case '/user/tables':
        return MaterialPageRoute(
            builder: (_) => const user_table.TableListScreen());
      case '/user/bookings':
        return MaterialPageRoute(
            builder: (_) => const user_booking.BookingListScreen());
      case '/user/news':
        return MaterialPageRoute(builder: (_) => const NewsScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

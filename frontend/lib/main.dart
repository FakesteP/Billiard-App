import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'routes.dart';
import 'screens/splash_screen.dart';
import 'services/auth_service.dart';
import 'services/table_service.dart';
import 'services/booking_service.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => TableService()),
        ChangeNotifierProvider(create: (_) => BookingService()), // Tambahkan ini
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billiard Booking',
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash', // pastikan initialRoute ke /splash
      onGenerateRoute: RouteGenerator.generateRoute,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

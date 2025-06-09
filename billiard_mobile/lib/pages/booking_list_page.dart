import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../services/api_service.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({Key? key}) : super(key: key);

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  late Future<List> _futureBookings;

  @override
  void initState() {
    super.initState();
    _futureBookings = fetchBookings(context);
  }

  void _refreshBookings() {
    setState(() {
      _futureBookings = fetchBookings(context);
    });
  }

  Future<void> _handleMenuAction(
      String value, int bookingId, BuildContext context) async {
    if (value == 'completed') {
      await updateStatus(bookingId, 'completed', context);
      _refreshBookings();
    } else if (value == 'delete') {
      await deleteBooking(bookingId, context);
      _refreshBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final role = Provider.of<AuthProvider>(context, listen: false).role;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.backgroundColor,
              AppTheme.backgroundColor.withOpacity(0.9),
              AppTheme.surfaceColor.withOpacity(0.8),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppTheme.cardColor.withOpacity(0.9),
                      AppTheme.surfaceColor.withOpacity(0.8),
                    ],
                  ),
                  border: Border(
                    bottom: BorderSide(
                      color: AppTheme.borderColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppTheme.primaryColor,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.primaryColor,
                            AppTheme.accentColor,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.bookmark,
                        color: AppTheme.textPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        role == 'admin' ? 'Semua Booking' : 'Booking Saya',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bookings List
              Expanded(
                child: FutureBuilder(
                  future: _futureBookings,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.primaryColor.withOpacity(0.2),
                                    AppTheme.accentColor.withOpacity(0.2),
                                  ],
                                ),
                              ),
                              child: const CircularProgressIndicator(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading bookings...',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppTheme.textSecondary,
                                  ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.errorColor.withOpacity(0.1),
                                border: Border.all(
                                  color: AppTheme.errorColor.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: const Icon(
                                Icons.error_outline,
                                size: 48,
                                color: AppTheme.errorColor,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error: ${snapshot.error}',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: AppTheme.errorColor,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    } else {
                      final bookings = snapshot.data as List;
                      if (bookings.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppTheme.surfaceColor,
                                  border: Border.all(
                                    color:
                                        AppTheme.borderColor.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.calendar_today,
                                  size: 48,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada booking',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async => _refreshBookings(),
                        color: AppTheme.primaryColor,
                        backgroundColor: AppTheme.cardColor,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: bookings.length,
                          itemBuilder: (context, index) {
                            final booking = bookings[index];
                            final status = booking['status'] as String;
                            Color statusColor = AppTheme.textSecondary;
                            IconData statusIcon = Icons.schedule;

                            if (status == 'confirmed') {
                              statusColor = AppTheme.successColor;
                              statusIcon = Icons.check_circle;
                            } else if (status == 'completed') {
                              statusColor = AppTheme.primaryColor;
                              statusIcon = Icons.done_all;
                            } else if (status == 'cancelled') {
                              statusColor = AppTheme.errorColor;
                              statusIcon = Icons.cancel;
                            }

                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    AppTheme.cardColor.withOpacity(0.9),
                                    AppTheme.surfaceColor.withOpacity(0.8),
                                  ],
                                ),
                                border: Border.all(
                                  color: AppTheme.borderColor.withOpacity(0.3),
                                  width: 1,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 15,
                                    spreadRadius: 2,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.primaryColor
                                                    .withOpacity(0.2),
                                                AppTheme.accentColor
                                                    .withOpacity(0.2),
                                              ],
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.table_restaurant,
                                            color: AppTheme.primaryColor,
                                            size: 24,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Meja ${booking['table_id']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      color:
                                                          AppTheme.textPrimary,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              const SizedBox(height: 4),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: statusColor
                                                      .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: statusColor
                                                        .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      statusIcon,
                                                      size: 16,
                                                      color: statusColor,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      status.toUpperCase(),
                                                      style: TextStyle(
                                                        color: statusColor,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (role == 'admin')
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppTheme.surfaceColor
                                                  .withOpacity(0.5),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: AppTheme.borderColor
                                                    .withOpacity(0.3),
                                                width: 1,
                                              ),
                                            ),
                                            child: PopupMenuButton<String>(
                                              icon: const Icon(
                                                Icons.more_vert,
                                                color: AppTheme.textSecondary,
                                              ),
                                              onSelected: (value) {
                                                _handleMenuAction(value,
                                                    booking['id'], context);
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                    value: 'completed',
                                                    child:
                                                        Text('Set Completed')),
                                                const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Hapus')),
                                              ],
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),

                                    // Booking Details
                                    Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppTheme.surfaceColor
                                            .withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppTheme.borderColor
                                              .withOpacity(0.3),
                                          width: 1,
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildDetailRow(
                                            context,
                                            icon: Icons.calendar_today,
                                            label: 'Tanggal',
                                            value: booking['date'],
                                          ),
                                          const SizedBox(height: 12),
                                          _buildDetailRow(
                                            context,
                                            icon: Icons.access_time,
                                            label: 'Waktu',
                                            value:
                                                '${booking['start_time']} - ${booking['end_time']}',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Future<List> fetchBookings(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final role = authProvider.role;
    final userId = authProvider.userId;
    try {
      final response = await ApiService.get(
        '/bookings',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return role == 'customer'
            ? data.where((b) => b['user_id'] == userId).toList()
            : data;
      } else {
        throw Exception('Gagal memuat data booking');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: \\${e.toString()}');
    }
  }

  Future<void> updateStatus(int id, String status, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    try {
      final response = await ApiService.put(
        '/bookings/$id',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'status': status}),
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Status updated to $status')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal update status: \\${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: \\${e.toString()}')),
      );
    }
  }

  Future<void> deleteBooking(int id, BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    try {
      final response = await ApiService.delete(
        '/bookings/$id',
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking deleted')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Gagal menghapus booking: \\${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: \\${e.toString()}')),
      );
    }
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    super.initState();
    // Gunakan addPostFrameCallback agar context sudah terpasang provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingService>(context, listen: false).fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    final bookingService = Provider.of<BookingService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Bookings'),
      ),
      body: bookingService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookingService.bookings.length,
              itemBuilder: (context, index) {
                final BookingModel booking = bookingService.bookings[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text('Table: ${booking.tableName}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('User: ${booking.userName}'),
                        Text('Date: ${booking.date}'),
                        Text('Time: ${booking.startTime} - ${booking.endTime}'),
                        Text('Status: ${booking.status}'),
                        if (booking.createdAt.isNotEmpty)
                          Text('Created: ${booking.createdAt}',
                              style: const TextStyle(fontSize: 12)),
                        if (booking.updatedAt.isNotEmpty)
                          Text('Updated: ${booking.updatedAt}',
                              style: const TextStyle(fontSize: 12)),
                      ],
                    ),
                    trailing: StatefulBuilder(
                      builder: (context, setStateDropdown) =>
                          DropdownButton<String>(
                        value: booking.status,
                        items: const [
                          DropdownMenuItem(
                            value: 'pending',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: 'confirmed',
                            child: Text('Confirmed'),
                          ),
                          DropdownMenuItem(
                            value: 'completed',
                            child: Text('Completed'),
                          ),
                          DropdownMenuItem(
                            value: 'cancelled',
                            child: Text('Cancelled'),
                          ),
                        ],
                        onChanged: (value) async {
                          if (value != null && value != booking.status) {
                            await _updateBookingStatus(booking.id, value);
                            setStateDropdown(() {}); // Refresh dropdown only
                          }
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _updateBookingStatus(String bookingId, String status) async {
    await Provider.of<BookingService>(context, listen: false)
        .updateBookingStatus(bookingId, status);
    // Refresh booking list setelah update status
    await Provider.of<BookingService>(context, listen: false).fetchBookings();
    // Optional: tampilkan notifikasi
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking status updated')),
      );
    }
  }
}

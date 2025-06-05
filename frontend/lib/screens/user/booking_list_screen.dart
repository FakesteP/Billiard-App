import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking_model.dart';
import '../../models/table_model.dart';
import '../../services/booking_service.dart';
import '../../services/table_service.dart';
import '../../screens/user/booking_form_screen.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<BookingService>(context, listen: false).fetchUserBookings();
    });
  }

  Future<void> _openBookingForm(BuildContext context) async {
    final tableService = Provider.of<TableService>(context, listen: false);
    await tableService.fetchTables();
    final availableTables =
        tableService.tables.where((t) => t.status == 'available').toList();

    if (availableTables.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No available tables to book.')),
      );
      return;
    }

    TableModel? selectedTable;
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Table'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: availableTables.length,
              itemBuilder: (context, index) {
                final table = availableTables[index];
                return ListTile(
                  title: Text(table.name),
                  subtitle: Text('Status: ${table.status}'),
                  onTap: () {
                    selectedTable = table;
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedTable != null) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BookingFormScreen(table: selectedTable!),
        ),
      );
      Provider.of<BookingService>(context, listen: false).fetchUserBookings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingService = Provider.of<BookingService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Book Table',
            onPressed: () => _openBookingForm(context),
          ),
        ],
      ),
      body: bookingService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookingService.userBookings.isEmpty
              ? const Center(child: Text('No bookings found'))
              : ListView.builder(
                  itemCount: bookingService.userBookings.length,
                  itemBuilder: (context, index) {
                    final BookingModel booking =
                        bookingService.userBookings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 16),
                      child: ListTile(
                        title: Text('Table: ${booking.tableName}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${booking.date}'),
                            Text(
                                'Time: ${booking.startTime} - ${booking.endTime}'),
                            Text('Status: ${booking.status}'),
                            if (booking.createdAt.isNotEmpty)
                              Text('Created: ${booking.createdAt}',
                                  style: const TextStyle(fontSize: 12)),
                            if (booking.updatedAt.isNotEmpty)
                              Text('Updated: ${booking.updatedAt}',
                                  style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: DropdownButton<String>(
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
                              await Provider.of<BookingService>(context,
                                      listen: false)
                                  .updateBookingStatus(booking.id, value);
                              await Provider.of<BookingService>(context,
                                      listen: false)
                                  .fetchUserBookings();
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Status updated')),
                                );
                              }
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Future<void> _cancelBooking(String bookingId) async {
    await Provider.of<BookingService>(context, listen: false)
        .cancelBooking(bookingId);
  }
}

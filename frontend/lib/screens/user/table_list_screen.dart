import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/table_model.dart';
import '../../services/table_service.dart';
import '../../services/booking_service.dart';
import 'booking_form_screen.dart';

class TableListScreen extends StatefulWidget {
  const TableListScreen({super.key});

  @override
  State<TableListScreen> createState() => _TableListScreenState();
}

class _TableListScreenState extends State<TableListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TableService>(context, listen: false).fetchTables();
    });
  }

  @override
  Widget build(BuildContext context) {
    final tableService = Provider.of<TableService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Tables'),
      ),
      body: tableService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: tableService.tables.length,
              itemBuilder: (context, index) {
                final table = tableService.tables[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: (table.imageUrl.isNotEmpty &&
                            (table.imageUrl.startsWith('http://') ||
                                table.imageUrl.startsWith('https://')))
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(table.imageUrl),
                          )
                        : const CircleAvatar(child: Icon(Icons.table_bar)),
                    title: Text(table.name),
                    subtitle: Text('Status: ${table.status}'),
                    trailing: ElevatedButton(
                      onPressed: table.status == 'available'
                          ? () {
                              _showBookingDialog(context, table.id);
                            }
                          : null,
                      child: const Text('Book Now'),
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _showBookingDialog(BuildContext context, String tableId) {
    final _dateController = TextEditingController();
    final _startTimeController = TextEditingController();
    final _endTimeController = TextEditingController();
    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Book Table'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _dateController,
                    decoration:
                        const InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter date' : null,
                  ),
                  TextFormField(
                    controller: _startTimeController,
                    decoration:
                        const InputDecoration(labelText: 'Start Time (HH:MM)'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter start time' : null,
                  ),
                  TextFormField(
                    controller: _endTimeController,
                    decoration:
                        const InputDecoration(labelText: 'End Time (HH:MM)'),
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Enter end time' : null,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          try {
                            await Provider.of<BookingService>(context,
                                    listen: false)
                                .createBooking(
                              tableId: tableId,
                              date: _dateController.text.trim(),
                              startTime: _startTimeController.text.trim(),
                              endTime: _endTimeController.text.trim(),
                            );
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Booking successful!')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Booking failed: $e')),
                            );
                          } finally {
                            setState(() => _isLoading = false);
                          }
                        }
                      },
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Book'),
              ),
            ],
          ),
        );
      },
    );
  }
}

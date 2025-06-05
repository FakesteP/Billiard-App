import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/table_model.dart';
import '../../services/booking_service.dart';
import '../../widgets/custom_button.dart';

class BookingFormScreen extends StatefulWidget {
  final TableModel table;

  const BookingFormScreen({super.key, required this.table});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _startTime = picked;
        // Reset end time if start time changes
        _endTime = null;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? (_startTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  Future<void> _submitBooking() async {
    if (_formKey.currentState!.validate()) {
      final bookingService =
          Provider.of<BookingService>(context, listen: false);

      try {
        await bookingService.createBooking(
          tableId: widget.table.id,
          date: DateFormat('yyyy-MM-dd').format(_selectedDate),
          startTime: _startTime != null
              ? '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}'
              : '',
          endTime: _endTime != null
              ? '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}'
              : '',
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Booking berhasil!')),
          );
          Navigator.pushNamedAndRemoveUntil(
              context, '/user/home', (route) => false);
        }
      } catch (e) {
        // Tangkap error 409 (Conflict) dan tampilkan pesan khusus
        String msg = 'Booking gagal: Waktu atau meja sudah dibooking.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg)),
        );
      }
    }
  }

  String? _validateTime() {
    if (_startTime == null) return 'Please select start time';
    if (_endTime == null) return 'Please select end time';
    final start =
        Duration(hours: _startTime!.hour, minutes: _startTime!.minute);
    final end = Duration(hours: _endTime!.hour, minutes: _endTime!.minute);
    if (end <= start) return 'End time must be after start time';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book ${widget.table.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Table: ${widget.table.name}',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Booking Date',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.all(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(DateFormat('EEEE, MMM d, y').format(_selectedDate)),
                      // Tidak perlu pilih tanggal, selalu hari ini
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Start Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    await _selectStartTime(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                        suffixIcon: Icon(Icons.access_time),
                        hintText: 'Select start time',
                      ),
                      controller: TextEditingController(
                        text: _startTime != null
                            ? _startTime!.format(context)
                            : '',
                      ),
                      validator: (value) {
                        if (_startTime == null)
                          return 'Please select start time';
                        return null;
                      },
                      readOnly: true,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'End Time',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    await _selectEndTime(context);
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.all(12),
                        suffixIcon: Icon(Icons.access_time),
                        hintText: 'Select end time',
                      ),
                      controller: TextEditingController(
                        text: _endTime != null ? _endTime!.format(context) : '',
                      ),
                      validator: (value) {
                        if (_endTime == null) return 'Please select end time';
                        if (_validateTime() != null) return _validateTime();
                        return null;
                      },
                      readOnly: true,
                    ),
                  ),
                ),
                if (_validateTime() != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _validateTime()!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ),
                const SizedBox(height: 30),
                CustomButton(
                  text: 'Confirm Booking',
                  onPressed: () {
                    if (_validateTime() == null) {
                      _submitBooking();
                    } else {
                      setState(() {});
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

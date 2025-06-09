import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';

class BookingFormPage extends StatefulWidget {
  final int tableId;
  const BookingFormPage({Key? key, required this.tableId}) : super(key: key);

  @override
  State<BookingFormPage> createState() => _BookingFormPageState();
}

class _BookingFormPageState extends State<BookingFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  bool isLoading = false;
  String? errorMessage;

  Future<void> submit() async {
    if (!_formKey.currentState!.validate() || selectedDate == null || startTime == null || endTime == null) return;
    setState(() { isLoading = true; errorMessage = null; });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final userId = authProvider.userId;
    try {
      final response = await http.post(
        Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/bookings'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'user_id': userId,
          'table_id': widget.tableId,
          'date': selectedDate!.toIso8601String().substring(0, 10),
          'start_time': startTime!.hour.toString().padLeft(2, '0') + ':' + startTime!.minute.toString().padLeft(2, '0'),
          'end_time': endTime!.hour.toString().padLeft(2, '0') + ':' + endTime!.minute.toString().padLeft(2, '0'),
        }),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        Navigator.pop(context, true);
      } else {
        final data = response.body.isNotEmpty ? jsonDecode(response.body) : null;
        setState(() {
          errorMessage = data != null && data['message'] != null
              ? 'Gagal booking: ' + data['message']
              : 'Gagal booking (${response.statusCode}): ' + response.body;
        });
      }
    } catch (e) {
      setState(() { errorMessage = 'Terjadi kesalahan'; });
    }
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Booking Meja')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ListTile(
                title: Text(selectedDate == null
                    ? 'Pilih Tanggal'
                    : '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) setState(() => selectedDate = picked);
                },
              ),
              ListTile(
                title: Text(startTime == null ? 'Pilih Jam Mulai' : startTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => startTime = picked);
                },
              ),
              ListTile(
                title: Text(endTime == null ? 'Pilih Jam Selesai' : endTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) setState(() => endTime = picked);
                },
              ),
              const SizedBox(height: 16),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              ElevatedButton(
                onPressed: isLoading ? null : submit,
                child: isLoading ? const CircularProgressIndicator() : const Text('Booking'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

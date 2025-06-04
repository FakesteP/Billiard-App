// ================================
// lib/screens/admin/booking_list_screen.dart - List Booking Admin
// ================================
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/booking_model.dart';
import '../../services/booking_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class BookingListScreen extends StatefulWidget {
  @override
  _BookingListScreenState createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  List<BookingModel> _bookings = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  _loadBookings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      List<BookingModel> bookings = await BookingService.getAllBookings();
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _updateBookingStatus(String bookingId, BookingStatus status) async {
    bool success = await BookingService.updateBookingStatus(bookingId, status);
    if (success) {
      _loadBookings();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status booking berhasil diupdate')),
      );
    }
  }

  _showScoreDialog(BookingModel booking) {
    final player1Controller = TextEditingController();
    final player2Controller = TextEditingController();
    String? selectedWinner;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Input Skor Permainan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Skor Player 1',
                controller: player1Controller,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Skor Player 2',
                controller: player2Controller,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              Text('Pemenang:'),
              RadioListTile<String>(
                title: Text('Player 1'),
                value: 'player1',
                groupValue: selectedWinner,
                onChanged: (value) {
                  setState(() {
                    selectedWinner = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: Text('Player 2'),
                value: 'player2',
                groupValue: selectedWinner,
                onChanged: (value) {
                  setState(() {
                    selectedWinner = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Batal'),
            ),
            CustomButton(
              text: 'Simpan',
              width: 100,
              height: 40,
              onPressed: () async {
                if (player1Controller.text.isNotEmpty &&
                    player2Controller.text.isNotEmpty &&
                    selectedWinner != null) {
                  
                  String? winnerId = selectedWinner == 'player1' ? booking.userId : 'player2_id';
                  
                  bool success = await BookingService.updateGameResult(
                    booking.id,
                    int.parse(player1Controller.text),
                    int.parse(player2Controller.text),
                    winnerId,
                  );
                  
                  Navigator.pop(context);
                  
                  if (success) {
                    _loadBookings();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Skor berhasil disimpan')),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text('Daftar Booking'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: _bookings.length,
              itemBuilder: (context, index) {
                BookingModel booking = _bookings[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Booking #${booking.id}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Chip(
                              label: Text(
                                _getStatusText(booking.status),
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              backgroundColor: _getStatusColor(booking.status),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text('Meja: ${booking.tableId}'),
                        Text('Tanggal: ${booking.bookingDate.day}/${booking.bookingDate.month}/${booking.bookingDate.year}'),
                        Text('Waktu: ${booking.startTime.hour}:${booking.startTime.minute.toString().padLeft(2, '0')} - ${booking.endTime.hour}:${booking.endTime.minute.toString().padLeft(2, '0')}'),
                        Text('Total: Rp ${booking.totalPrice.toStringAsFixed(0)}'),
                        
                        if (booking.player1Score != null && booking.player2Score != null) ...[
                          SizedBox(height: 8),
                          Text('Skor: ${booking.player1Score} - ${booking.player2Score}'),
                          Text('Poin: ${booking.pointsEarned}'),
                        ],
                        
                        SizedBox(height: 16),
                        Row(
                          children: [
                            if (booking.status == BookingStatus.pending)
                              Expanded(
                                child: CustomButton(
                                  text: 'Konfirmasi',
                                  height: 35,
                                  onPressed: () => _updateBookingStatus(booking.id, BookingStatus.confirmed),
                                ),
                              ),
                            if (booking.status == BookingStatus.confirmed) ...[
                              Expanded(
                                child: CustomButton(
                                  text: 'Mulai Main',
                                  height: 35,
                                  onPressed: () => _updateBookingStatus(booking.id, BookingStatus.playing),
                                ),
                              ),
                            ],
                            if (booking.status == BookingStatus.playing) ...[
                              Expanded(
                                child: CustomButton(
                                  text: 'Input Skor',
                                  height: 35,
                                  onPressed: () => _showScoreDialog(booking),
                                ),
                              ),
                            ],
                            if (booking.status == BookingStatus.pending || booking.status == BookingStatus.confirmed) ...[
                              SizedBox(width: 8),
                              Expanded(
                                child: CustomButton(
                                  text: 'Batal',
                                  height: 35,
                                  backgroundColor: Colors.red,
                                  onPressed: () => _updateBookingStatus(booking.id, BookingStatus.cancelled),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return Colors.orange;
      case BookingStatus.confirmed:
        return Colors.blue;
      case BookingStatus.playing:
        return Colors.purple;
      case BookingStatus.completed:
        return Colors.green;
      case BookingStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return 'Menunggu';
      case BookingStatus.confirmed:
        return 'Dikonfirmasi';
      case BookingStatus.playing:
        return 'Sedang Main';
      case BookingStatus.completed:
        return 'Selesai';
      case BookingStatus.cancelled:
        return 'Dibatalkan';
    }
  }
}


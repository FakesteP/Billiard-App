// ================================
// lib/screens/user/table_list_screen.dart - Daftar Meja untuk User
// ================================
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/table_model.dart';
import '../../services/table_service.dart';

class TableListScreen extends StatefulWidget {
  @override
  _TableListScreenState createState() => _TableListScreenState();
}

class _TableListScreenState extends State<TableListScreen> {
  List<TableModel> tables = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTables();
  }

  _loadTables() async {
    try {
      final loadedTables = await TableService.getTables();
      setState(() {
        tables = loadedTables;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading tables: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text('Pilih Meja Bilyar'),
        backgroundColor: AppConstants.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => _loadTables(),
              child: tables.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.table_restaurant,
                            size: 64,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Belum ada meja tersedia',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: tables.length,
                      itemBuilder: (context, index) {
                        final table = tables[index];
                        return _buildTableCard(table);
                      },
                    ),
            ),
    );
  }

  Widget _buildTableCard(TableModel table) {
    Color statusColor;
    String statusText;
    bool canBook = false;

    switch (table.status) {
      case 'available':
        statusColor = Colors.green;
        statusText = 'Tersedia';
        canBook = true;
        break;
      case 'occupied':
        statusColor = Colors.red;
        statusText = 'Sedang Digunakan';
        break;
      case 'booked':
        statusColor = Colors.orange;
        statusText = 'Sudah Dibooking';
        break;
      default:
        statusColor = Colors.grey;
        statusText = 'Tidak Tersedia';
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      child: InkWell(
        onTap: canBook ? () => _showBookingDialog(table) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppConstants.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.table_restaurant,
                  size: 32,
                  color: AppConstants.primaryColor,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      table.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rp ${table.pricePerHour.toStringAsFixed(0)}/jam',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppConstants.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (canBook)
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                  size: 16,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBookingDialog(TableModel table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Booking ${table.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Harga: Rp ${table.pricePerHour.toStringAsFixed(0)}/jam'),
            SizedBox(height: 8),
            Text('Apakah Anda yakin ingin booking meja ini?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _bookTable(table);
            },
            child: Text('Booking'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _bookTable(TableModel table) async {
    try {
      // TODO: Implement booking logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Booking ${table.name} berhasil!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadTables(); // Refresh data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal booking: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
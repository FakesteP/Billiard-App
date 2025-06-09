import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';
import 'table_form_page.dart';
import 'booking_form_page.dart';
import '../model/table_model.dart';
import '../services/api_service.dart';

class TableListPage extends StatefulWidget {
  const TableListPage({super.key});

  @override
  State<TableListPage> createState() => _TableListPageState();
}

class _TableListPageState extends State<TableListPage> {
  List<TableModel> tables = [];

  @override
  void initState() {
    super.initState();
    fetchTables();
  }

  Future<void> fetchTables() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    try {
      final response = await ApiService.get(
        '/tables',
        headers: token != null ? {'Authorization': 'Bearer $token'} : {},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        tables = data.map((e) => TableModel.fromJson(e)).toList();
      } else {
        tables = [];
      }
    } catch (e) {
      tables = [];
    }
    if (!mounted) return;
    setState(() {});
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
                        Icons.table_restaurant,
                        color: AppTheme.textPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Daftar Meja',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),

              // Tables List
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchTables,
                  color: AppTheme.primaryColor,
                  backgroundColor: AppTheme.cardColor,
                  child: tables.isEmpty
                      ? Center(
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
                                  Icons.table_restaurant,
                                  size: 48,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Tidak ada meja tersedia',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      color: AppTheme.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: tables.length,
                          itemBuilder: (context, index) {
                            final table = tables[index];
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
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: role == 'customer'
                                      ? () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => BookingFormPage(
                                                  tableId: table.id),
                                            ),
                                          );
                                          if (result == true) fetchTables();
                                        }
                                      : null,
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        // Table Image
                                        Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            gradient: LinearGradient(
                                              colors: [
                                                AppTheme.primaryColor
                                                    .withOpacity(0.1),
                                                AppTheme.accentColor
                                                    .withOpacity(0.1),
                                              ],
                                            ),
                                            border: Border.all(
                                              color: AppTheme.borderColor
                                                  .withOpacity(0.3),
                                              width: 1,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            child: table.imageUrl != null
                                                ? Image.network(
                                                    table.imageUrl!,
                                                    fit: BoxFit.cover,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const Icon(
                                                      Icons.table_restaurant,
                                                      size: 40,
                                                      color: AppTheme
                                                          .textSecondary,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.table_restaurant,
                                                    size: 40,
                                                    color:
                                                        AppTheme.textSecondary,
                                                  ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),

                                        // Table Info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                table.name,
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
                                              const SizedBox(height: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: table.isAvailable
                                                      ? AppTheme.successColor
                                                          .withOpacity(0.1)
                                                      : AppTheme.errorColor
                                                          .withOpacity(0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: table.isAvailable
                                                        ? AppTheme.successColor
                                                            .withOpacity(0.3)
                                                        : AppTheme.errorColor
                                                            .withOpacity(0.3),
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Icon(
                                                      table.isAvailable
                                                          ? Icons.check_circle
                                                          : Icons.cancel,
                                                      size: 16,
                                                      color: table.isAvailable
                                                          ? AppTheme
                                                              .successColor
                                                          : AppTheme.errorColor,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      table.isAvailable
                                                          ? 'Tersedia'
                                                          : 'Tidak tersedia',
                                                      style: TextStyle(
                                                        color: table.isAvailable
                                                            ? AppTheme
                                                                .successColor
                                                            : AppTheme
                                                                .errorColor,
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

                                        // Action Button
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
                                              onSelected: (value) async {
                                                if (value == 'edit') {
                                                  final result =
                                                      await Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          TableFormPage(
                                                              table: table
                                                                  .toJson()),
                                                    ),
                                                  );
                                                  if (result == true)
                                                    fetchTables();
                                                } else if (value == 'delete') {
                                                  final authProvider =
                                                      Provider.of<AuthProvider>(
                                                          context,
                                                          listen: false);
                                                  final token =
                                                      authProvider.token;
                                                  final url =
                                                      '/tables/${table.id}';
                                                  try {
                                                    final response =
                                                        await ApiService.delete(
                                                      url,
                                                      headers: {
                                                        'Authorization':
                                                            'Bearer $token'
                                                      },
                                                    );
                                                    if (response.statusCode ==
                                                        200) {
                                                      fetchTables();
                                                    } else {
                                                      if (!mounted) return;
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        const SnackBar(
                                                            content: Text(
                                                                'Gagal menghapus meja')),
                                                      );
                                                    }
                                                  } catch (e) {
                                                    if (!mounted) return;
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                          content: Text(
                                                              'Terjadi kesalahan')),
                                                    );
                                                  }
                                                }
                                              },
                                              itemBuilder: (context) => [
                                                const PopupMenuItem(
                                                    value: 'edit',
                                                    child: Text('Edit')),
                                                const PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Hapus')),
                                              ],
                                            ),
                                          )
                                        else if (role == 'customer')
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppTheme.primaryColor
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: AppTheme.primaryColor,
                                              size: 20,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: role == 'admin'
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primaryColor,
                    AppTheme.accentColor,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 15,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: FloatingActionButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TableFormPage(),
                    ),
                  );
                  if (result == true) {
                    fetchTables();
                  }
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: const Icon(
                  Icons.add,
                  color: AppTheme.textPrimary,
                  size: 28,
                ),
              ),
            )
          : null,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/table_model.dart';
import '../../services/table_service.dart';
import 'table_form_screen.dart';

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

  Future<void> _refreshTables() async {
    await Provider.of<TableService>(context, listen: false).fetchTables();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final tableService = Provider.of<TableService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Tables'),
      ),
      body: tableService.isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshTables,
              child: ListView.builder(
                itemCount: tableService.tables.length,
                itemBuilder: (context, index) {
                  final TableModel table = tableService.tables[index];
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: ListTile(
                      leading: (table.imageUrl.isNotEmpty && (table.imageUrl.startsWith('http://') || table.imageUrl.startsWith('https://')))
                          ? CircleAvatar(
                              backgroundImage: NetworkImage(table.imageUrl),
                            )
                          : const CircleAvatar(child: Icon(Icons.table_bar)),
                      title: Text(table.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Status: ${table.status}'),
                          if (table.createdAt.isNotEmpty)
                            Text('Created: ${table.createdAt}',
                                style: const TextStyle(fontSize: 12)),
                          if (table.updatedAt.isNotEmpty)
                            Text('Updated: ${table.updatedAt}',
                                style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              await Navigator.pushNamed(
                                context,
                                '/admin/tables/form',
                                arguments: table,
                              );
                              await _refreshTables();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () async {
                              await _deleteTable(context, table.id);
                              await _refreshTables();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(
            context,
            '/admin/tables/form',
            arguments: null,
          );
          await _refreshTables();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteTable(BuildContext context, String tableId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this table?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      await Provider.of<TableService>(context, listen: false)
          .deleteTable(tableId);
      Navigator.pop(context); // Tutup loading dialog
    }
  }
}

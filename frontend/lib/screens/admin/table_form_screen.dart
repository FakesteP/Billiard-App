import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/table_model.dart';
import '../../services/table_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class TableFormScreen extends StatefulWidget {
  final TableModel? table;

  const TableFormScreen({super.key, this.table});

  @override
  State<TableFormScreen> createState() => _TableFormScreenState();
}

class _TableFormScreenState extends State<TableFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  String _status = 'available';

  @override
  void initState() {
    super.initState();
    if (widget.table != null) {
      _nameController.text = widget.table!.name;
      _imageUrlController.text = widget.table!.imageUrl;
      _status = widget.table!.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveTable() async {
    if (_formKey.currentState!.validate()) {
      final tableService = Provider.of<TableService>(context, listen: false);
      final table = TableModel(
        id: widget.table?.id ?? '',
        name: _nameController.text.trim(),
        status: _status,
        imageUrl: _imageUrlController.text.trim(),
        createdAt: widget.table?.createdAt ?? DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
      );

      if (widget.table == null) {
        await tableService.addTable(table);
      } else {
        await tableService.updateTable(table);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.table == null ? 'Add Table' : 'Edit Table'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Table Name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter table name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _imageUrlController,
                label: 'Image URL',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _status,
                items: const [
                  DropdownMenuItem(
                    value: 'available',
                    child: Text('Available'),
                  ),
                  DropdownMenuItem(
                    value: 'pending',
                    child: Text('pending'),
                  ),
                  DropdownMenuItem(
                    value: 'maintenance',
                    child: Text('Maintenance'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _status = value!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Save',
                onPressed: _saveTable,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

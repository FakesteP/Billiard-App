// ================================
// lib/screens/admin/table_form_screen.dart - Form Tambah/Edit Meja
// ================================
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../models/table_model.dart';
import '../../services/table_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class TableFormScreen extends StatefulWidget {
  @override
  _TableFormScreenState createState() => _TableFormScreenState();
}

class _TableFormScreenState extends State<TableFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _priceController = TextEditingController();

  TableStatus _selectedStatus = TableStatus.available;
  bool _isLoading = false;
  TableModel? _editingTable;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final TableModel? table =
        ModalRoute.of(context)?.settings.arguments as TableModel?;
    if (table != null && _editingTable == null) {
      _editingTable = table;
      _nameController.text = table.name;
      _descriptionController.text = table.description;
      _imageUrlController.text = table.imageUrl;
      _priceController.text = table.pricePerHour.toString();
      _selectedStatus = table.status;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _imageUrlController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  _saveTable() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      TableModel table = TableModel(
        id: _editingTable?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        imageUrl: _imageUrlController.text,
        status: _selectedStatus,
        pricePerHour: double.tryParse(_priceController.text) ?? 0.0,
      );

      try {
        if (_editingTable == null) {
          await TableService.addTable(table);
        } else {
          await TableService.updateTable(table);
        }
        Navigator.of(context).pop();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan meja. Coba lagi!')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_editingTable == null ? 'Tambah Meja' : 'Edit Meja'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextField(
                controller: _nameController,
                label: 'Nama Meja',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama meja wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                label: 'Deskripsi',
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Deskripsi wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _imageUrlController,
                label: 'URL Gambar',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'URL gambar wajib diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                controller: _priceController,
                label: 'Harga per Jam',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Harga wajib diisi';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Masukkan angka yang valid';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<TableStatus>(
                value: _selectedStatus,
                decoration: InputDecoration(
                  labelText: 'Status',
                  border: OutlineInputBorder(),
                ),
                items: TableStatus.values.map((status) {
                  return DropdownMenuItem<TableStatus>(
                    value: status,
                    child: Text(status == TableStatus.available
                        ? 'Tersedia'
                        : 'Tidak Tersedia'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                },
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : CustomButton(
                      text: _editingTable == null ? 'Simpan' : 'Update',
                      onPressed: _saveTable,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../providers/auth_provider.dart';
import '../services/api_service.dart';

class TableFormPage extends StatefulWidget {
  final Map<String, dynamic>? table;
  const TableFormPage({Key? key, this.table}) : super(key: key);

  @override
  State<TableFormPage> createState() => _TableFormPageState();
}

class _TableFormPageState extends State<TableFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController imageUrlController;
  String status = 'available';
  bool isLoading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.table?['name'] ?? '');
    imageUrlController =
        TextEditingController(text: widget.table?['image_url'] ?? '');
    status = widget.table?['status'] ?? 'available';
  }

  @override
  void dispose() {
    nameController.dispose();
    imageUrlController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      isLoading = true;
      errorMessage = null;
    });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final isEdit = widget.table != null;
    final url = isEdit ? '/tables/${widget.table!['id']}' : '/tables';
    try {
      final response = await (isEdit
          ? ApiService.put(
              url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({
                'name': nameController.text,
                'status': status,
                'image_url': imageUrlController.text,
              }),
            )
          : ApiService.post(
              url,
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'Bearer $token',
              },
              body: jsonEncode({
                'name': nameController.text,
                'status': status,
                'image_url': imageUrlController.text,
              }),
            ));
      if (response.statusCode == 200 || response.statusCode == 201) {
        Navigator.pop(context, true);
      } else {
        final data = jsonDecode(response.body);
        setState(() {
          errorMessage = data['message'] ?? 'Gagal menyimpan data';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan';
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Meja'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Nama Meja'),
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      TextFormField(
                        controller: imageUrlController,
                        decoration:
                            const InputDecoration(labelText: 'Image URL'),
                      ),
                      DropdownButtonFormField<String>(
                        value: status,
                        items: const [
                          DropdownMenuItem(
                              value: 'available', child: Text('Available')),
                          DropdownMenuItem(
                              value: 'pending', child: Text('Pending')),
                          DropdownMenuItem(
                              value: 'booked', child: Text('Booked')),
                        ],
                        onChanged: (val) {
                          setState(() {
                            status = val!;
                          });
                        },
                        decoration: const InputDecoration(labelText: 'Status'),
                      ),
                      const SizedBox(height: 16),
                      if (errorMessage != null)
                        Text(errorMessage!,
                            style: const TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isLoading ? null : submit,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

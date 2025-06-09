import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List users = [];
  bool isLoading = true;
  String? errorMessage;

  Future<void> fetchUsers() async {
    setState(() { isLoading = true; errorMessage = null; });
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    try {
      final response = await http.get(
        Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/users'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          users = data;
        } else if (data is Map && data['users'] is List) {
          users = data['users'];
        } else {
          errorMessage = 'Format data user tidak dikenali';
        }
      } else if (response.statusCode == 404) {
        errorMessage = 'Endpoint /users tidak ditemukan di server (404). Cek URL endpoint di backend.';
        debugPrint('Response body: ' + response.body);
      } else if (response.statusCode == 401) {
        errorMessage = 'Akses ditolak. Silakan login ulang.';
      } else {
        errorMessage = 'Gagal memuat data user (${response.statusCode}): ' + response.body;
      }
    } catch (e) {
      errorMessage = 'Terjadi kesalahan';
    }
    setState(() { isLoading = false; });
  }

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar User')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(child: Text(errorMessage!))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text(user['username'] ?? '-'),
                      subtitle: Text(user['email'] ?? '-'),
                      trailing: Text(user['role'] ?? '-'),
                    );
                  },
                ),
    );
  }
}

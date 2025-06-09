import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../model/user.dart';
import '../services/api_service.dart';

class UserListPage extends StatefulWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  State<UserListPage> createState() => _UserListPageState();
}

class _UserListPageState extends State<UserListPage> {
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final token = authProvider.token;
    final url = '/users';
    try {
      final response = await ApiService.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        users = data
            .map((e) => User(
                  id: e['id'],
                  name: e['username'] ??
                      '', // gunakan username jika tidak ada name
                  email: e['email'] ?? '',
                ))
            .toList();
      } else {
        users = [];
      }
    } catch (e) {
      users = [];
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar User'),
        centerTitle: true,
      ),
      body: users.isEmpty
          ? const Center(child: Text('Tidak ada user'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Theme.of(context).cardColor,
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                  ),
                );
              },
            ),
    );
  }
}

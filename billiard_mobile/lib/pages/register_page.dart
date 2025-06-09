import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String role = 'customer';
  bool isLoading = false;
  String? errorMessage;
  String? successMessage;

  void register() async {
    setState(() { isLoading = true; errorMessage = null; successMessage = null; });
    final url = Uri.parse('https://api-billiard-1061342868557.us-central1.run.app/auth/register');
    try {
      final response = await Provider.of<AuthProvider>(context, listen: false).register(
        usernameController.text.trim(),
        emailController.text.trim(),
        passwordController.text.trim(),
        role,
      );
      if (response == true) {
        setState(() { successMessage = 'Registrasi berhasil, silakan login.'; });
      } else {
        setState(() { errorMessage = Provider.of<AuthProvider>(context, listen: false).errorMessage; });
      }
    } catch (e) {
      setState(() { errorMessage = 'Terjadi kesalahan'; });
    }
    setState(() { isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: role,
              items: const [
                DropdownMenuItem(value: 'customer', child: Text('Customer')),
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
              ],
              onChanged: (val) {
                setState(() { role = val!; });
              },
            ),
            const SizedBox(height: 16),
            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            if (successMessage != null)
              Text(successMessage!, style: const TextStyle(color: Colors.green)),
            ElevatedButton(
              onPressed: isLoading ? null : register,
              child: isLoading ? const CircularProgressIndicator() : const Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
              },
              child: const Text('Sudah punya akun? Login'),
            ),
          ],
        ),
      ),
    );
  }
}

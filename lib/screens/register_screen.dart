import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../utils/navigation_utils.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _roleController = TextEditingController(); // Controller untuk role
  final ApiService _apiService = ApiService();

  void _register() async {
    final user = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final role = _roleController.text.trim();

    if (user.isEmpty || username.isEmpty || password.isEmpty || role.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi semua kolom')),
      );
      return;
    }

    try {
      print('Mencoba mendaftar dengan: $user, $username, $role');
      final success =
          await _apiService.registerUser(user, username, password, role);
      if (success) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', user);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil')),
        );
        navigateTo(context, '/login');
      }
    } catch (e) {
      print('Error saat registrasi: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal registrasi: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _roleController,
                    decoration: InputDecoration(
                      labelText: 'Role (e.g., admin/user)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      navigateTo(context, '/login');
                    },
                    child: const Text(
                      'Sudah punya akun? Login di sini',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey[50],
    );
  }
}

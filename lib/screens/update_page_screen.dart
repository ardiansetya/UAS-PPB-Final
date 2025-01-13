import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class UpdateUserScreen extends StatefulWidget {
  final int userId; // ID pengguna yang akan diperbarui

  const UpdateUserScreen({required this.userId, super.key});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'customer';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _userController.text = prefs.getString('user') ?? '';
    _usernameController.text = prefs.getString('username') ?? '';
    _passwordController.text = prefs.getString('password') ?? '';
    setState(() {
      _role = prefs.getString('role') ?? 'customer';
    });
  }

  Future<void> _updateUser() async {
    try {
      bool success = await _apiService.updateUser(
        widget.userId,
        _userController.text,
        _usernameController.text,
        _passwordController.text,
        _role,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Update failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update User'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heading
              const Text(
                'Perbarui Data Pengguna',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Nama pengguna
              TextField(
                controller: _userController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Username
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Password
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // Dropdown untuk memilih role
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: _role,
                  onChanged: (String? newValue) {
                    setState(() {
                      _role = newValue!;
                    });
                  },
                  isExpanded: true,
                  underline:
                      const SizedBox(), // Menghilangkan underline default
                  items: <String>['customer', 'admin']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              // Tombol Update
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateUser,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Update User',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

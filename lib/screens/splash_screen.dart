import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Menunda navigasi selama 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      // Memastikan widget masih aktif sebelum melakukan navigasi
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/splashscreen.webp', width: 200, height: 200),
            SizedBox(height: 20),
            Text(
              'Selamat Datang di UMKM Warung Ajib',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

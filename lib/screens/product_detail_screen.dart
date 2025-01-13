import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<Product> _product;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _product = _apiService.fetchProductById(widget.productId);
  }

  Future<void> _addToCart(int userId, int quantity) async {
    try {
      await _apiService.addToCart(userId, widget.productId, quantity);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Produk berhasil ditambahkan ke keranjang!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan ke keranjang: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Produk'),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<Product>(
        future: _product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, color: Colors.red, size: 50),
                  const SizedBox(height: 10),
                  Text('Error: ${snapshot.error}',
                      style: TextStyle(fontSize: 16)),
                ],
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Produk tidak ditemukan'));
          } else {
            final product = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    elevation: 5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.network(
                        product.imageUrl,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Harga: Rp${product.price}',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            size: 30, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            if (_quantity > 1) {
                              _quantity--;
                            }
                          });
                        },
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline,
                            size: 30, color: Colors.blue),
                        onPressed: () {
                          setState(() {
                            _quantity++;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      final prefs = await SharedPreferences.getInstance();
                      final userId = prefs.getInt('user_id');
                      if (userId != null) {
                        _addToCart(userId, _quantity);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Silakan login terlebih dahulu')),
                        );
                      }
                    },
                    child: const Text(
                      'Tambah ke Keranjang',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

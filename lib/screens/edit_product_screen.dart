import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  const EditProductScreen({super.key, required this.product});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.product.name;
    _priceController.text = widget.product.price.toString();
    _descriptionController.text = widget.product.description;
    _imageUrlController.text = widget.product.imageUrl;
  }

  Future<void> _updateProduct() async {
    final updatedProduct = Product(
      id: widget.product.id,
      name: _nameController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
      description: _descriptionController.text,
      imageUrl: _imageUrlController.text, // URL gambar baru
    );

    try {
      await _apiService.updateProduct(updatedProduct);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk berhasil diperbarui')),
      );
      Navigator.pop(context); // Kembali ke halaman sebelumnya
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui produk: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Produk')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Menampilkan pratinjau gambar dari URL
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
                image: DecorationImage(
                  image: NetworkImage(_imageUrlController.text),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _imageUrlController,
              decoration: InputDecoration(
                labelText: 'URL Gambar',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Masukkan URL gambar produk',
              ),
              onChanged: (value) {
                setState(() {}); // Memperbarui pratinjau gambar
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Nama Produk',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Harga Produk',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi Produk',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _updateProduct,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text(
                'Perbarui Produk',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

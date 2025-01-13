import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4, // Menambahkan bayangan
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(12), // Membuat sudut kartu melengkung
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar produk
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              // Nama produk
              Text(
                name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              // Deskripsi produk
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              // Harga produk
              Text(
                'Rp$price',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const Spacer(),
              // Tombol aksi
              Center(
                child: ElevatedButton(
                  onPressed: onTap,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Warna tombol
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white, // Warna teks menjadi putih
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

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class DetailPage extends StatefulWidget {
  final String? kota_asal;
  final String? kota_tujuan;
  final String? berat;
  final String? kurir;
  final int userId;

  const DetailPage({
    super.key,
    this.kota_asal,
    this.kota_tujuan,
    this.berat,
    this.kurir,
    required this.userId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List listData = [];
  var strKey = "e5effe93f8bdd6e8e8f09d1d4a1a42c6";
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(
        Uri.parse("https://api.rajaongkir.com/starter/cost"),
        body: {
          "key": strKey,
          "origin": widget.kota_asal,
          "destination": widget.kota_tujuan,
          "weight": widget.berat,
          "courier": widget.kurir?.toLowerCase(),
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          listData = data['rajaongkir']['results'][0]['costs'];
        });
      } else {
        throw Exception('Gagal memuat data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Detail Ongkos Kirim ${widget.kurir?.toUpperCase() ?? ''}",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pilih Layanan Pengiriman",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listData.length,
                    itemBuilder: (context, index) {
                      final item = listData[index];
                      final cost = item['cost'][0];

                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    item['service'] ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Rp ${cost['value']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                item['description'] ?? '',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Estimasi: ${cost['etd']} Hari",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  double shippingCost =
                                      double.parse(cost['value'].toString());
                                  // Tambahkan fungsi onPressed di sini
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Pilih Layanan",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}

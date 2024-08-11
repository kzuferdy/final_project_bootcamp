import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../main_page.dart';

class StatusPage extends StatelessWidget {
  final String paymentId;

  StatusPage({required this.paymentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Pembayaran'),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF021526),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('payments').doc(paymentId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Pembayaran tidak ditemukan.'));
          } else {
            final paymentData = snapshot.data!.data() as Map<String, dynamic>;
            final paymentStatus = paymentData['status'] ?? 'Tidak diketahui';
            final paymentMethod = paymentData['paymentMethod'] ?? 'Tidak diketahui';
            final amount = paymentData['amount'] ?? 0;
            final products = paymentData['products'] as List<dynamic>?;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 4,
                      margin: EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Status Pembayaran:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(paymentStatus, style: TextStyle(fontSize: 16)),
                            SizedBox(height: 8),
                            Text('Metode Pembayaran:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(paymentMethod, style: TextStyle(fontSize: 16)),
                            SizedBox(height: 8),
                            Text('Jumlah:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('Rp${amount.toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                          ],
                        ),
                      ),
                    ),
                    Text('Detail Produk:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 10),
                    if (products != null && products.isNotEmpty) ...[
                      ...products.map((product) {
                        final productMap = product as Map<String, dynamic>;
                        return Card(
                          elevation: 4,
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Nama Produk:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(productMap['title'], style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text('Kategori:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(productMap['category'], style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text('Deskripsi:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text(productMap['description'], style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text('Stok:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('${productMap['stock']}', style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text('Harga:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('Rp${productMap['price'].toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                                SizedBox(height: 8),
                                Text('Jumlah:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                Text('${productMap['quantity']}', style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                productMap['image'] != null ? Image.network(productMap['image']) : Container(),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ] else ...[
                      Text('Tidak ada detail produk.', style: TextStyle(fontSize: 16)),
                    ],
                    SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF021526),
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => MainPage()),
                        );
                      },
                      child: Text('Kembali ke Halaman Produk', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

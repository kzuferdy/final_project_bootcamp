import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../payment/payment_statuspage.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String? selectedPaymentMethod;
  String? selectedCategory;
  String? selectedProduct;

  final Color primaryGreen = Color(0xFF4CAF50);
  final Color lightGreen = Color(0xFFE8F5E9);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogoHeader(),
              SizedBox(height: 16.0),
              _buildSectionHeader('Filter'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    _buildDropdown(
                      'Kategori Produk',
                      ['Elektronik', 'Baju', 'Jewerly'],
                      (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              _buildSectionHeader('Laporan Checkout'),
              _buildCheckoutReport(),
              SizedBox(height: 16.0),
              _buildPaymentStatusButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Image.asset(
          'assets/images/shop.png', // Ganti dengan path logo Anda
          height: 80.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryGreen, primaryGreen.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.only(bottom: 16.0),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: primaryGreen),
      ),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: primaryGreen),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: items
            .map((item) => DropdownMenuItem(
                  value: item,
                  child: Text(item),
                ))
            .toList(),
        onChanged: onChanged,
        dropdownColor: Colors.white,
      ),
    );
  }

  Widget _buildCheckoutReport() {
    return StreamBuilder<QuerySnapshot>(
      stream: _filteredCheckout(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryGreen)));
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red)));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('Belum ada data checkout.', style: TextStyle(color: primaryGreen)));
        } else {
          return Column(
            children: snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              final product = data['product'] as Map<String, dynamic>;
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  title: Text('Produk: ${product['title']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kategori: ${product['category']}'),
                      Text('Deskripsi: ${product['description']}'),
                      Text('Harga: Rp${data['price']}'),
                      Text('Jumlah: ${data['quantity']}'),
                      Text('Waktu: ${data['timestamp']?.toDate() ?? 'Unknown'}'),
                    ],
                  ),
                  isThreeLine: true,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(product['image'], width: 50, height: 50, fit: BoxFit.cover),
                  ),
                ),
              );
            }).toList(),
          );
        }
      },
    );
  }

 Widget _buildPaymentStatusButton(BuildContext context) {
  return Center(
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: primaryGreen, padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Text color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 5,
        shadowColor: primaryGreen.withOpacity(0.5),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => PaymentStatusPage(),
        ));
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.payment, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'Lihat Status Pembayaran',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

  Stream<QuerySnapshot> _filteredCheckout() {
    Query query = FirebaseFirestore.instance.collection('checkout');

    if (selectedCategory != null) {
      query = query.where('product.category', isEqualTo: selectedCategory);
    }

    if (selectedProduct != null) {
      query = query.where('product.title', isEqualTo: selectedProduct);
    }

    return query.snapshots();
  }
}

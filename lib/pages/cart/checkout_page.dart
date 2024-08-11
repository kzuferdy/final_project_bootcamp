import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../logic/cart/cart_bloc.dart';
import '../../model/cart_model.dart';
import '../payment/payment_page.dart';

class CheckoutPage extends StatelessWidget {
  final List<CartItem> selectedItems;

  CheckoutPage({required this.selectedItems});

  Widget _buildLogoHeader() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/shop.png', // Ganti dengan path logo Anda
          height: 120.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021526),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLogoHeader(),
            SizedBox(height: 16), // Add space between logo and ListView
            Expanded(
              child: ListView.builder(
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  final cartItem = selectedItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          cartItem.product.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        cartItem.product.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 8),
                          Text(
                            'Harga: Rp${cartItem.product.price.toStringAsFixed(2)}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Jumlah: ${cartItem.quantity}',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(color: Colors.grey[300]),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16), // Add space between ListView and button
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final firestore = FirebaseFirestore.instance;
                    final batch = firestore.batch();

                    // Simpan data checkout dan produk ke Firestore
                    for (var cartItem in selectedItems) {
                      final checkoutDocRef = firestore.collection('checkout').doc();
                      batch.set(checkoutDocRef, {
                        'product': {
                          'id': cartItem.product.id,
                          'title': cartItem.product.title,
                          'category': cartItem.product.category,
                          'description': cartItem.product.description,
                          'price': cartItem.product.price,
                          'image': cartItem.product.image,
                          'stock': cartItem.product.stock,
                        },
                        'quantity': cartItem.quantity,
                        'price': cartItem.product.price * cartItem.quantity,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                      // Hapus item dari keranjang
                      final cartItemDocRef = firestore.collection('cart').doc(cartItem.id.toString());
                      batch.delete(cartItemDocRef);
                    }

                    await batch.commit();

                    // Navigasi ke halaman pembayaran
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PaymentPage()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Terjadi kesalahan: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700], // Customize button color
                  foregroundColor: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 84, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: TextStyle(
                    
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: Text('Bayar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

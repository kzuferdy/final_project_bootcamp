import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../model/product_model.dart';
import 'edit_product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  Future<void> addToCart(Product product) async {
    try {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      await firestore.collection('cart').add({
        'productId': product.id,
        'title': product.title,
        'description': product.description,
        'category': product.category,
        'image': product.image,
        'price': product.price,
        'stock': product.stock, // Menambahkan stok ke keranjang
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding to cart: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProductPage(product: product),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.network(product.image),
          const SizedBox(height: 16),
          Text(
            product.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            '\RP${product.price}',
            style: const TextStyle(fontSize: 20, color: Colors.green),
          ),
          const SizedBox(height: 16),
          Text(
            'Stok: ${product.stock}', // Menampilkan stok produk
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            product.description,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Product added to cart')),
              );
            },
            child: const Text('Add to Cart'),
          ),
        ],
      ),
    );
  }
}



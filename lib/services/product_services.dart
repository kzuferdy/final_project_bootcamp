import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/product_model.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Product>> fetchProducts() async {
  try {
    QuerySnapshot snapshot = await _firestore.collection('products').get();
    List<Product> products = snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      print('Document Data: $data'); // Tambahkan logging
      return Product.fromJson(data);
    }).toList();
    return products;
  } catch (e) {
    print('Error: ${e.toString()}'); // Tambahkan logging
    throw Exception('Failed to load products: ${e.toString()}');
  }
}

  Future<void> updateProduct(Product product) async {
    try {
      // Konversi ID produk menjadi String
      final docRef = _firestore.collection('products').doc(product.id.toString());
      await docRef.update(product.toJson());
    } catch (e) {
      throw Exception('Failed to update product: ${e.toString()}');
    }
  }
  Future<Product> fetchProductById(String productId) async {
    try {
      final docRef = _firestore.collection('products').doc(productId);
      final docSnapshot = await docRef.get();
      if (!docSnapshot.exists) {
        throw Exception('Product not found');
      }
      final data = docSnapshot.data() as Map<String, dynamic>;
      return Product.fromJson(data);
    } catch (e) {
      throw Exception('Failed to load product: ${e.toString()}');
    }
  }
}
// class ProductService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<Product>> fetchProducts() async {
//     try {
//       // Mengambil data dari koleksi 'products' di Firestore
//       QuerySnapshot snapshot = await _firestore.collection('products').get();
//       List<Product> products = snapshot.docs
//           .map((doc) {
//             print('Document Data: ${doc.data()}'); // Tambahkan logging
//             Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//             print('Document ID: ${data['id']}'); // Tambahkan logging
//             return Product.fromJson(data);
//           })
//           .toList();
//       return products;
//     } catch (e) {
//       print('Error: ${e.toString()}'); // Tambahkan logging
//       throw Exception('Failed to load products: ${e.toString()}');
//     }
//   }
  
// }
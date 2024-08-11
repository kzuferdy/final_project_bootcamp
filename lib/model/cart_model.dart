import 'product_model.dart';

// Model CartItem
class CartItem {
  final String id; // ID dari Firestore, biasanya string
  final Product product;
  final int quantity;
  bool isSelected; // Tambahkan properti isSelected

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
    this.isSelected = false,
  });

  factory CartItem.fromFirestore(Map<String, dynamic> data, String id) {
    return CartItem(
      id: id,
      product: Product.fromJson(data),
      quantity: data['quantity'] ?? 1, // Mendapatkan quantity dari Firestore
    );
  }
}
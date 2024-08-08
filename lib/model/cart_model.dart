import 'product_model.dart';

// Model CartItem
class CartItem {
  final String id; // ID dari Firestore, biasanya string
  final Product product;

  CartItem({
    required this.id,
    required this.product,
  });

  factory CartItem.fromFirestore(Map<String, dynamic> data, String id) {
    return CartItem(
      id: id,
      product: Product.fromJson(data),
    );
  }
}
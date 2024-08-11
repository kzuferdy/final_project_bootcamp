import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  final Map<String, dynamic> product;
  final int quantity;
  final double totalPrice;
  final String paymentMethod;
  final Timestamp timestamp;

  Report({
    required this.product,
    required this.quantity,
    required this.totalPrice,
    required this.paymentMethod,
    required this.timestamp,
  });

  factory Report.fromMap(Map<String, dynamic> map) {
    return Report(
      product: map['product'] as Map<String, dynamic>,
      quantity: map['quantity'] as int,
      totalPrice: (map['totalPrice'] as num).toDouble(),
      paymentMethod: map['paymentMethod'] as String,
      timestamp: map['timestamp'] as Timestamp,
    );
  }
}
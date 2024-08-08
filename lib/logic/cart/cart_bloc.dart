import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../model/cart_model.dart';
import '../../model/product_model.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  CartBloc() : super(CartLoading()) {
    on<LoadCartItems>((event, emit) async {
      try {
        emit(CartLoading());
        final cartSnapshot = await firestore.collection('cart').get();
        final cartItems = cartSnapshot.docs.map((doc) {
          final data = doc.data();
          final product = Product(
            id: data['productId'],
            title: data['title'],
            description: data['description'],
            category: data['category'],
            image: data['image'],
            price: data['price'],
            stock: data['stock'],
          );
          return CartItem(product: product, id: doc.id);
        }).toList();
        emit(CartLoaded(cartItems));
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<RemoveFromCart>((event, emit) async {
      try {
        await firestore.collection('cart').doc(event.productId).delete();
        add(LoadCartItems());
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });
  }
}

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
          return CartItem(
            id: doc.id,
            product: product,
            quantity: data['quantity'] ?? 1,
          );
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

    on<UpdateCartItemQuantity>((event, emit) async {
      try {
        final docRef = firestore.collection('cart').doc(event.cartItemId);
        await docRef.update({'quantity': event.newQuantity});
        add(LoadCartItems());
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });

    on<ClearCart>((event, emit) async {
      try {
        final batch = firestore.batch();
        final cartDocs = await firestore.collection('cart').get();
        for (var doc in cartDocs.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        add(LoadCartItems());
      } catch (e) {
        emit(CartError(e.toString()));
      }
    });
    on<ToggleCartItemSelection>((event, emit) {
      if (state is CartLoaded) {
        final cartItems = (state as CartLoaded).cartItems;
        final updatedItems = cartItems.map((item) {
          if (item.id == event.cartItemId) {
            return CartItem(
              id: item.id,
              product: item.product,
              quantity: item.quantity,
              isSelected: event.isSelected,
            );
          }
          return item;
        }).toList();
        emit(CartLoaded(updatedItems));
      }
    });
  }
}

  


// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:equatable/equatable.dart';

// import '../../model/cart_model.dart';
// import '../../model/product_model.dart';

// part 'cart_event.dart';
// part 'cart_state.dart';

// class CartBloc extends Bloc<CartEvent, CartState> {
//   final FirebaseFirestore firestore = FirebaseFirestore.instance;

//   CartBloc() : super(CartLoading()) {
//     on<LoadCartItems>((event, emit) async {
//       try {
//         emit(CartLoading());
//         final cartSnapshot = await firestore.collection('cart').get();
//         final cartItems = cartSnapshot.docs.map((doc) {
//           final data = doc.data();
//           final product = Product(
//             id: data['productId'],
//             title: data['title'],
//             description: data['description'],
//             category: data['category'],
//             image: data['image'],
//             price: data['price'],
//             stock: data['stock'],
//           );
//           return CartItem(product: product, id: doc.id);
//         }).toList();
//         emit(CartLoaded(cartItems));
//       } catch (e) {
//         emit(CartError(e.toString()));
//       }
//     });

//     on<RemoveFromCart>((event, emit) async {
//       try {
//         await firestore.collection('cart').doc(event.productId).delete();
//         add(LoadCartItems());
//       } catch (e) {
//         emit(CartError(e.toString()));
//       }
//     });
//   }
// }
// class UpdateCartItemQuantity extends CartEvent {
//   final String cartItemId;
//   final int newQuantity;

//   UpdateCartItemQuantity(this.cartItemId, this.newQuantity);
// }

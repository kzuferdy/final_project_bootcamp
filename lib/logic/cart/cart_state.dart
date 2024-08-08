part of 'cart_bloc.dart';

class CartState {}

class CartLoading extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> cartItems;

  CartLoaded(this.cartItems);
}

class CartError extends CartState {
  final String message;

  CartError(this.message);
}

part of 'cart_bloc.dart';

class CartEvent {}

class LoadCartItems extends CartEvent {}

class RemoveFromCart extends CartEvent {
  final String productId;

  RemoveFromCart(this.productId);
}
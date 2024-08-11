part of 'cart_bloc.dart';

class CartEvent {}

class LoadCartItems extends CartEvent {}

class RemoveFromCart extends CartEvent {
  final String productId;

  RemoveFromCart(this.productId);
}

class UpdateCartItemQuantity extends CartEvent {
  final String cartItemId;
  final int newQuantity;

  UpdateCartItemQuantity(this.cartItemId, this.newQuantity);
}

class ClearCart extends CartEvent {}
class ToggleCartItemSelection extends CartEvent {
  final String cartItemId;
  final bool isSelected;

  ToggleCartItemSelection(this.cartItemId, this.isSelected);
}

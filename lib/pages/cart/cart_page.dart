import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cart/cart_bloc.dart';
import 'checkout_page.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021526),
      body: BlocProvider(
        create: (context) => CartBloc()..add(LoadCartItems()),
        child: Column(
          children: [
            _buildLogoHeader(), // Tambahkan logo di bagian atas halaman
            Expanded(
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is CartLoaded) {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: state.cartItems.length,
                            itemBuilder: (context, index) {
                              final cartItem = state.cartItems[index];
                              return Card(
                                color: Color(0xFFA2DE96),
                                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          cartItem.product.image,
                                          width: 80,
                                          height: 80,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItem.product.title,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Text('Harga: Rp${cartItem.product.price}',
                                                style: TextStyle(color: Colors.green[900])),
                                            Text('Stok: ${cartItem.product.stock}',
                                                style: TextStyle(color: Colors.grey[900])),
                                            SizedBox(height: 8),
                                            Row(
                                              children: [
                                                IconButton(
                                                  icon: Icon(Icons.remove, color: Colors.red),
                                                  onPressed: () {
                                                    if (cartItem.quantity > 1) {
                                                      context.read<CartBloc>().add(UpdateCartItemQuantity(cartItem.id, cartItem.quantity - 1));
                                                    }
                                                  },
                                                ),
                                                Text('${cartItem.quantity}', style: TextStyle(fontSize: 16)),
                                                IconButton(
                                                  icon: Icon(Icons.add, color: Colors.green),
                                                  onPressed: () {
                                                    if (cartItem.quantity < cartItem.product.stock) {
                                                      context.read<CartBloc>().add(UpdateCartItemQuantity(cartItem.id, cartItem.quantity + 1));
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            Text('Total: Rp${cartItem.product.price * cartItem.quantity}',
                                                style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                                          ],
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Checkbox(
                                            value: cartItem.isSelected,
                                            onChanged: (bool? value) {
                                              context.read<CartBloc>().add(ToggleCartItemSelection(cartItem.id, value ?? false));
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () {
                                              context.read<CartBloc>().add(RemoveFromCart(cartItem.id));
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () {
                                  final selectedItems = state.cartItems.where((item) => item.isSelected).toList();
                                  if (selectedItems.isNotEmpty) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CheckoutPage(selectedItems: selectedItems)),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('Pilih setidaknya satu item untuk checkout')),
                                    );
                                  }
                                },
                                icon: Icon(Icons.shopping_cart),
                                label: Text('Checkout'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green[700],
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () {
                                  context.read<CartBloc>().add(ClearCart());
                                },
                                icon: Icon(Icons.cancel),
                                label: Text('Batalkan Pesanan'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[700],
                                  foregroundColor: Colors.black,
                                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else if (state is CartError) {
                    return Center(child: Text(state.message));
                  } else {
                    return Center(child: Text('Keranjang Anda kosong.'));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Image.asset(
          'assets/images/shop.png', // Ganti dengan path logo Anda
          height: 120.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

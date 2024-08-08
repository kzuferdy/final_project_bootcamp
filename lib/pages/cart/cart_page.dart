import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cart/cart_bloc.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
      ),
      body: BlocProvider(
        create: (context) => CartBloc()..add(LoadCartItems()),
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is CartLoaded) {
              return ListView.builder(
                itemCount: state.cartItems.length,
                itemBuilder: (context, index) {
                  final cartItem = state.cartItems[index];
                  return ListTile(
                    leading: Image.network(cartItem.product.image),
                    title: Text(cartItem.product.title),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Harga: Rp${cartItem.product.price}'),
                        Text('Stok: ${cartItem.product.stock}'), // Menampilkan stok produk
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        context.read<CartBloc>().add(RemoveFromCart(cartItem.id));
                      },
                    ),
                  );
                },
              );
            } else if (state is CartError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text('Keranjang Anda kosong.'));
            }
          },
        ),
      ),
    );
  }
}



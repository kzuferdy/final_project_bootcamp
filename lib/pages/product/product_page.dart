import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/product/product_bloc.dart';
import '../../logic/product/product_event.dart';
import '../../logic/product/product_state.dart';
import '../../helper/notification_helper.dart';
import '../../services/product_services.dart';
import '../auth/login_page.dart';
import 'product_detail_page.dart';
import 'add_product_page.dart'; 

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA2DE96) ,
      body: BlocProvider(
        create: (context) => ProductBloc(ProductService())..add(FetchProducts()),
        child: Column(
          children: [
            SizedBox(height: 20),
            FilterTextFieldWithNotification(), // Menambahkan widget filter dengan ikon notifikasi, tambah produk, dan logout
            Expanded(child: ProductGrid()),
          ],
        ),
      ),
    );
  }
}

// Widget untuk filter produk dengan ikon notifikasi, tambah produk, dan logout
class FilterTextFieldWithNotification extends StatelessWidget {
  const FilterTextFieldWithNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Filter by name',
                prefixIcon: const Icon(Icons.filter_list, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (query) {
                context.read<ProductBloc>().add(SearchProducts(query));
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black), // Ikon notifikasi
            onPressed: () {
              NotificationHelper.flutterLocalNotificationsPlugin.show(
                0,
                'New Product Alert',
                'Check out our new product!',
                NotificationHelper.notificationDetails,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.black), // Ikon tambah produk
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black), // Ikon logout
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error logging out: ${e.toString()}')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class ProductGrid extends StatelessWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ProductLoaded) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // Jumlah kolom
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.75, // Rasio aspek dari item grid
            ),
            itemCount: state.products.length,
            itemBuilder: (context, index) {
              final product = state.products[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductDetailPage(product: product),
                    ),
                  );
                },
                child: Card(
                  elevation: 4.0,
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: Image.network(
                          product.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              '\RP${product.price.toString()}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        } else if (state is ProductError) {
          return Center(child: Text(state.message));
        } else {
          return const Center(child: Text('No products'));
        }
      },
    );
  }
}

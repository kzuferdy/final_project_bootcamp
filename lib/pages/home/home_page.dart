import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../helper/notification_helper.dart';
import '../../logic/product/product_bloc.dart';
import '../../logic/product/product_event.dart';
import '../../logic/product/product_state.dart';
import '../../logic/profile/profile_bloc.dart';
import '../../model/profile_model.dart';
import '../../services/product_services.dart';
import '../product/product_detail_page.dart';
import '../product/product_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return BlocProvider(
      create: (context) => ProfileBloc()..add(FetchUserProfile(userId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildLogoHeader(), 
              BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (state.errorMessage != null) {
                    return Center(child: Text(state.errorMessage!));
                  }

                  if (state.user != null) {
                    final userProfile = state.user as UserProfile;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Selamat Datang,',
                                    style: TextStyle(color: Colors.black, fontSize: 16),
                                  ),
                                  Text(
                                    userProfile.name,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              IconButton(
                                icon: Icon(Icons.notifications, color: Colors.black),
                                onPressed: () {
                                  NotificationHelper.flutterLocalNotificationsPlugin.show(
                                    0,
                                    'Ada Produk Bagus Nih!',
                                    'Cek Produk Baru Sekarang!',
                                    NotificationHelper.notificationDetails,
                                  );
                                },
                              ),
                              Positioned(
                                right: 11,
                                top: 11,
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  constraints: BoxConstraints(
                                    minWidth: 12,
                                    minHeight: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }

                  return Center(child: Text('Data pengguna tidak tersedia.'));
                },
              ),
              SizedBox(height: 20),
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: BlocProvider(
                        create: (context) => ProductBloc(ProductService())..add(FetchProducts()),
                        child: BlocBuilder<ProductBloc, ProductState>(
                          builder: (context, state) {
                            if (state is ProductLoading) {
                              return Center(child: CircularProgressIndicator());
                            } else if (state is ProductLoaded) {
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
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
                                    child: Container(
                                      width: 200,
                                      height: 120,
                                      margin: EdgeInsets.all(40.0),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF9764C7),
                                        borderRadius: BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 4.0,
                                            spreadRadius: 2.0,
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                                              child: Image.network(
                                                product.image,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: 100,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(18.0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  product.title,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                SizedBox(height: 14.0),
                                                Text(
                                                  '\RP${product.price.toString()}',
                                                  style: TextStyle(
                                                    color: Colors.black,
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
                              return Center(child: Text('No products'));
                            }
                          },
                        ),
                      ),
                    ),
                    // Tambahkan iklan di sini
                    Container(
                      height: 140, // Sesuaikan tinggi iklan
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          'assets/images/pos.png', // Ganti dengan URL gambar iklan Anda
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          height: 80.0,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

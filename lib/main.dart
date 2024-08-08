import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project_pos/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/product/product_bloc.dart';
import 'logic/product/product_event.dart';
import 'migrate.dart';
import 'model/product_model.dart';
import 'pages/splash_screen.dart';
import 'services/product_services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
        BlocProvider(
          create: (context) =>
              ProductBloc(ProductService())..add(FetchProducts()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
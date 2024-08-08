// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:logger/logger.dart';
// import 'model/product_model.dart';

// class ProductMigrationService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String apiUrl = 'https://fakestoreapi.com/products'; // URL API product
//   final Logger _logger = Logger();

//   Future<void> migrateProductData() async {
//     try {
//       // Ambil data dari API
//       final response = await http.get(Uri.parse(apiUrl));
//       if (response.statusCode == 200) {
//         // Parse response
//         final List<dynamic> productListJson = json.decode(response.body);
//         _logger.d("Data fetched from API: $productListJson");

//         // Referensi ke koleksi products di Firestore
//         CollectionReference productsCollection = _firestore.collection('products');

//         // Tambahkan data product ke Firestore
//         for (var productJson in productListJson) {
//           final product = Product.fromJson(productJson);
//           _logger.d("Saving product: $product");

//           await productsCollection.doc(product.id.toString()).set({
//             'id': product.id,
//             'title': product.title,
//             'description': product.description,
//             'category': product.category,
//             'image': product.image,
//             'price': product.price,
//           });

//           _logger.d("Product ${product.id} saved successfully.");
//         }

//         _logger.i("Product data berhasil dipindahkan ke Firestore.");
//       } else {
//         throw Exception('Gagal mengambil data product dari API');
//       }
//     } catch (e) {
//       _logger.e('Error: $e');
//     }
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   try {
//     await Firebase.initializeApp();
//     runApp(MyApp());
//   } catch (e) {
//     Logger().e("Error initializing Firebase: $e");
//   }
// }

// class MyApp extends StatelessWidget {
//   final ProductMigrationService _migrationService = ProductMigrationService();

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Product Migration',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Product Migration'),
//         ),
//         body: Center(
//           child: ElevatedButton(
//             onPressed: () async {
//               await _migrationService.migrateProductData();
//             },
//             child: Text('Migrate Product Data'),
//           ),
//         ),
//       ),
//     );
//   }
// }
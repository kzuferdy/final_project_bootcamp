import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  String _category = '';
  String _image = '';
  double _price = 0.0;
  int _stock = 0;

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Generate a new DocumentReference for Firestore to get the ID
      DocumentReference productRef = FirebaseFirestore.instance.collection('products').doc();

      // Save product to Firestore
      await productRef.set({
        'id': productRef.id, // Store the generated id
        'title': _title,
        'description': _description,
        'category': _category,
        'image': _image,
        'price': _price,
        'stock': _stock,
        'createdAt': FieldValue.serverTimestamp(),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Produk'),
        backgroundColor: Color(0xFFA2DE96), // Warna app bar
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  offset: Offset(0, 4),
                  blurRadius: 8.0,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildTextField('Title', 'Masukkan judul produk', (value) {
                      _title = value!;
                    }),
                    _buildTextField('Description', 'Masukkan deskripsi produk', (value) {
                      _description = value!;
                    }),
                    _buildTextField('Category', 'Masukkan kategori produk', (value) {
                      _category = value!;
                    }),
                    _buildTextField('Image URL', 'Masukkan URL gambar produk', (value) {
                      _image = value!;
                    }),
                    _buildTextField('Price', 'Masukkan harga produk', (value) {
                      _price = double.parse(value!);
                    }, keyboardType: TextInputType.number),
                    _buildTextField('Stock', 'Masukkan jumlah stok produk', (value) {
                      _stock = int.parse(value!);
                    }, keyboardType: TextInputType.number),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _saveProduct,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: Color(0xFFA2DE96), // Warna tombol
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                      child: Text('Simpan Produk'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, FormFieldSetter<String> onSaved, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.teal),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.teal, width: 2.0),
          ),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Harap masukkan $label';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'status_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage extends StatelessWidget {
  final List<String> ewalletOptions = ['OVO', 'GoPay', 'Dana', 'ShopeePay'];
  final List<String> bankOptions = ['BRI', 'BCA', 'Mandiri'];

  void _savePaymentData(BuildContext context, String paymentMethod) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Simpan data pembayaran di Firestore dengan status "success"
    DocumentReference docRef = await firestore.collection('payments').add({
      'paymentMethod': paymentMethod,
      'amount': 100000, // Jumlah pembayaran (dummy data)
      'status': 'success', // Set status to success
      'timestamp': Timestamp.now(),
    });

    // Arahkan ke halaman status setelah menyimpan data dengan paymentId yang benar
    String paymentId = docRef.id;
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StatusPage(paymentId: paymentId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF021526), // Background color
      appBar: AppBar(
        title: Text('Pembayaran'),
        foregroundColor: Colors.white,
        backgroundColor: Color(0xFF021526), // Customize AppBar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text(
              'Pilih Metode Pembayaran',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'E-Wallet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            ...ewalletOptions.map((ewallet) => Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  ewallet,
                  style: TextStyle(color: Colors.white),
                ),
                leading: Radio<String>(
                  value: ewallet,
                  groupValue: null, // Anda bisa menambahkan state management untuk nilai yang dipilih
                  onChanged: (value) {
                    _savePaymentData(context, value!);
                  },
                ),
              ),
            )).toList(),
            SizedBox(height: 20),
            Text(
              'Bank Transfer',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
            ...bankOptions.map((bank) => Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                title: Text(
                  bank,
                  style: TextStyle(color: Colors.white),
                ),
                leading: Radio<String>(
                  value: bank,
                  groupValue: null, // Anda bisa menambahkan state management untuk nilai yang dipilih
                  onChanged: (value) {
                    _savePaymentData(context, value!);
                  },
                ),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

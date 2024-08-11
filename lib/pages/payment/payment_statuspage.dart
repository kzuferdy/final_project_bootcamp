import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class PaymentStatusPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Status Pembayaran'),
        actions: [
          IconButton(
            icon: Icon(Icons.download),
            onPressed: () async {
              final pdf = pw.Document();
              final paymentsSnapshot = await FirebaseFirestore.instance.collection('payments').get();
              final payments = paymentsSnapshot.docs;

              for (var payment in payments) {
                final paymentData = payment.data() as Map<String, dynamic>;
                pdf.addPage(
                  pw.Page(
                    build: (pw.Context context) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Metode: ${paymentData['paymentMethod']}\n'
                          'Jumlah: Rp${paymentData['amount']}\n'
                          'Status: ${paymentData['status']}\n'
                          'Tanggal: ${_formatTimestamp(paymentData['timestamp'])}',
                          style: pw.TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
                );
              }

              await Printing.sharePdf(
                bytes: await pdf.save(),
                filename: 'status_pembayaran.pdf',
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('payments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('Tidak ada pembayaran yang ditemukan.'));
          }

          final payments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: payments.length,
            itemBuilder: (context, index) {
              final payment = payments[index];
              final paymentData = payment.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.all(8.0),
                elevation: 4,
                child: ListTile(
                  title: Text('Metode: ${paymentData['paymentMethod']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Jumlah: Rp${paymentData['amount']}'),
                      Text('Status: ${paymentData['status']}'),
                      Text(
                        'Tanggal: ${_formatTimestamp(paymentData['timestamp'])}',
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () async {
                          final pdf = pw.Document();
                          pdf.addPage(
                            pw.Page(
                              build: (pw.Context context) {
                                return pw.Padding(
                                  padding: const pw.EdgeInsets.all(8.0),
                                  child: pw.Text(
                                    'Metode: ${paymentData['paymentMethod']}\n'
                                    'Jumlah: Rp${paymentData['amount']}\n'
                                    'Status: ${paymentData['status']}\n'
                                    'Tanggal: ${_formatTimestamp(paymentData['timestamp'])}',
                                    style: pw.TextStyle(fontSize: 14),
                                  ),
                                );
                              },
                            ),
                          );
                          await Printing.sharePdf(
                            bytes: await pdf.save(),
                            filename: 'status_pembayaran_${payment.id}.pdf',
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Konfirmasi Hapus'),
                              content: Text('Apakah Anda yakin ingin menghapus status pembayaran ini?'),
                              actions: [
                                TextButton(
                                  child: Text('Batal'),
                                  onPressed: () => Navigator.of(context).pop(false),
                                ),
                                TextButton(
                                  child: Text('Hapus'),
                                  onPressed: () => Navigator.of(context).pop(true),
                                ),
                              ],
                            ),
                          );
                          if (confirm ?? false) {
                            await FirebaseFirestore.instance.collection('payments').doc(payment.id).delete();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}


// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';

// class PaymentStatusPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Status Pembayaran'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.download),
//             onPressed: () async {
//               final pdf = pw.Document();
//               final paymentsSnapshot = await FirebaseFirestore.instance.collection('payments').get();
//               final payments = paymentsSnapshot.docs;

//               pdf.addPage(
//                 pw.Page(
//                   build: (pw.Context context) {
//                     return pw.ListView.builder(
//                       itemCount: payments.length,
//                       itemBuilder: (context, index) {
//                         final paymentData = payments[index].data() as Map<String, dynamic>;

//                         return pw.Padding(
//                           padding: const pw.EdgeInsets.all(8.0),
//                           child: pw.Text(
//                             'Metode: ${paymentData['paymentMethod']}\n'
//                             'Jumlah: Rp${paymentData['amount']}\n'
//                             'Status: ${paymentData['status']}\n'
//                             'Tanggal: ${_formatTimestamp(paymentData['timestamp'])}',
//                             style: pw.TextStyle(fontSize: 14),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               );

//               await Printing.sharePdf(
//                 bytes: await pdf.save(),
//                 filename: 'status_pembayaran.pdf',
//               );
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<QuerySnapshot>(
//         stream: FirebaseFirestore.instance.collection('payments').snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('Tidak ada pembayaran yang ditemukan.'));
//           }

//           final payments = snapshot.data!.docs;

//           return ListView.builder(
//             itemCount: payments.length,
//             itemBuilder: (context, index) {
//               final payment = payments[index];
//               final paymentData = payment.data() as Map<String, dynamic>;

//               return Card(
//                 margin: const EdgeInsets.all(8.0),
//                 elevation: 4,
//                 child: ListTile(
//                   title: Text('Metode: ${paymentData['paymentMethod']}'),
//                   subtitle: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Jumlah: Rp${paymentData['amount']}'),
//                       Text('Status: ${paymentData['status']}'),
//                       Text(
//                         'Tanggal: ${_formatTimestamp(paymentData['timestamp'])}',
//                       ),
//                     ],
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }

//   String _formatTimestamp(Timestamp timestamp) {
//     // Format timestamp ke string yang lebih mudah dibaca
//     DateTime date = timestamp.toDate();
//     return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
//   }
// }

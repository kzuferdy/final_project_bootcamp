import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/report_model.dart';

class ReportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Method untuk mendapatkan laporan yang difilter berdasarkan kategori
  Stream<List<Report>> getFilteredReports({String? category}) {
    Query query = _firestore.collection('checkouts'); // Ganti 'checkouts' dengan nama koleksi laporan Anda

    if (category != null && category.isNotEmpty) {
      query = query.where('product.category', isEqualTo: category);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Report.fromMap(data);
      }).toList();
    });
  }
}
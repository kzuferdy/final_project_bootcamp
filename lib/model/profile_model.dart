import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  final String name;
  final String phone;
  final String email;

  UserProfile({
    required this.name,
    required this.phone,
    required this.email,
  });

  factory UserProfile.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserProfile(
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
    );
  }
}

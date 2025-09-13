import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String phoneNo;
  final DateTime createdAt;

  AppUser({
    required this.id,
    required this.phoneNo,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "phoneNo": phoneNo,
      "createdAt": createdAt,
    };
  }

  factory AppUser.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AppUser(
      id: doc.id,
      phoneNo: data["phoneNo"],
      createdAt: (data["createdAt"] as Timestamp).toDate(),
    );
  }
}

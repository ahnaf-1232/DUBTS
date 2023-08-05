import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  final String name;
  final List<String> code;

  Bus({
    required this.name,
    required this.code,
  });

  factory Bus.fromFirestore(QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    return Bus(
      name: doc['name'],
      code: List<String>.from(doc['code']),
    );
  }
}

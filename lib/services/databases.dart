import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{

  final CollectionReference collection= FirebaseFirestore.instance.collection('bus');

  Future updateUserData(String busName, String busCode) async {

  }
}
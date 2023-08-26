import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;


  Future<void> addBusDetailsToDB(dynamic bus_details) async {
    try {
      await _fireStore.collection('bus_schedules').add(bus_details);
      if (kDebugMode) {
        print("bus data added");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<dynamic> fetchAllDocuments(String collectionName) async {
    try {
      final collectionReference = _fireStore.collection(collectionName);
      final querySnapshot = await collectionReference.get();

      final documents = querySnapshot.docs;

      Map<String, dynamic> data = {};

      for (var document in documents) {
        // Access individual fields within the document
        data = document.data();
      }

      return data;
    } catch (e) {
      return null;
    }
  }




}
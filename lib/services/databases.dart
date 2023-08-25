import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class DatabaseService{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  static Future<Map<String, List<String>>> fetchBusData() async {
    FirebaseFirestore fireStore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await fireStore.collection('bus').get();

      Map<String, List<String>> busDetails = {};
      snapshot.docs.forEach((doc) {
        String name = doc['name'];
        List<String> codes = List<String>.from(doc['code']);
        busDetails[name] = codes;
      });

      return busDetails;
    } catch (e) {
      print("Error fetching data: $e");
      return {};
    }
  }

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

  static void printAllBusDetails(Map<String, List<String>> allBusDetails) {
    print("All Bus Details:");
    allBusDetails.forEach((name, codes) {
      print("Bus Name: $name");
      print("Codes: ${codes.join(', ')}");
    });
  }
}
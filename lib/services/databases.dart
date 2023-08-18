import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService{
  static Future<Map<String, List<String>>> fetchBusData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await firestore.collection('bus').get();

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

  static void printAllBusDetails(Map<String, List<String>> allBusDetails) {
    print("All Bus Details:");
    allBusDetails.forEach((name, codes) {
      print("Bus Name: $name");
      print("Codes: ${codes.join(', ')}");
    });
  }
}
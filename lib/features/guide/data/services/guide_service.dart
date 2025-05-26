import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import '../../domain/models/bus_schedule.dart';
import '../../domain/models/bus_location.dart';

class GuideService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  
  // Fetch all bus schedules from Firestore
  Stream<List<BusSchedule>> getBusSchedules() {
    return _firestore
        .collection('bus_schedules')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return BusSchedule.fromJson(data);
          }).toList();
        });
  }

  // Start tracking a bus
  Future<void> startBusTracking(String busCode, String time, String guideId) async {
    final locationRef = _database.child('bus_locations').child(busCode);
    
    // Listen to location changes
    Geolocator.getPositionStream().listen((Position position) {
      final busLocation = BusLocation(
        busCode: busCode,
        time: time,
        latitude: position.latitude,
        longitude: position.longitude,
        guideId: guideId,
      );
      
      locationRef.set(busLocation.toJson());
    });
  }

  // Stop tracking a bus
  Future<void> stopBusTracking(String busCode) async {
    await _database.child('bus_locations').child(busCode).remove();
  }

  // Get all active bus locations
  Stream<List<BusLocation>> getActiveBusLocations() {
    return _database
        .child('bus_locations')
        .onValue
        .map((event) {
          final Map<dynamic, dynamic>? data = event.snapshot.value as Map?;
          if (data == null) return [];

          return data.entries.map((entry) {
            return BusLocation.fromJson(Map<String, dynamic>.from(entry.value));
          }).toList();
        });
  }
}

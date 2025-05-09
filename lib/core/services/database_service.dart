import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubts/core/models/bus_location_model.dart';
import 'package:dubts/core/models/bus_model.dart';
import 'package:dubts/core/models/route_schedules.dart';
import 'package:dubts/core/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseDatabase _realtimeDb = FirebaseDatabase.instance;

  // Collection references
  CollectionReference get usersCollection => _firestore.collection('users');
  CollectionReference get busesCollection => _firestore.collection('bus_schedules');
  CollectionReference get busLocationsCollection => _firestore.collection('bus_locations');

  Future<FirebaseDatabase> get safeRealtimeDb async {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
    return FirebaseDatabase.instance;
  }

  // Create or update user data
  Future<void> createUserData(UserModel user) async {
    return await usersCollection.doc(user.uid).set(user.toMap());
  }

  // Get user data
  Future<UserModel?> getUserData(String uid) async {
    DocumentSnapshot doc = await usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  // Get all buses
  Stream<List<BusModel>> get buses {
    return busesCollection.snapshots().map(_busListFromSnapshot);
  }

  // Get buses by route
  Stream<List<BusModel>> getBusesByRoute(String route) {
    return busesCollection
        .where('route', isEqualTo: route)
        .snapshots()
        .map(_busListFromSnapshot);
  }

  // Get bus by id
  Future<BusModel?> getBusById(String id) async {
    DocumentSnapshot doc = await busesCollection.doc(id).get();
    if (doc.exists) {
      return BusModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  // Add new bus
  Future<DocumentReference> addBus(BusModel bus) async {
    return await busesCollection.add(bus.toMap());
  }

  // Update bus
  Future<void> updateBus(BusModel bus) async {
    return await busesCollection.doc(bus.id).update(bus.toMap());
  }

  // Delete bus
  Future<void> deleteBus(String busId) async {
    return await busesCollection.doc(busId).delete();
  }

  // Get bus location
  Stream<BusLocationModel?> getBusLocation(String busId) {
    return _realtimeDb.ref('bus_locations/$busId').onValue.map((event) {
      final data = event.snapshot.value;
      if (data != null && data is Map) {
        final castedData = Map<String, dynamic>.from(data);
        return BusLocationModel.fromMap(castedData);
      }
      return null;
    });
  }

  // Update bus location
  Future<void> updateBusLocation(BusLocationModel location) async {
    final db = await safeRealtimeDb;
    print('Pushing to RTDB: ${location.toMap()}');
    await db.ref('bus_locations/${location.busId}').set(location.toMap());
  }

  // Bus list from snapshot
  List<BusModel> _busListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return BusModel.fromMap(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }

  Future<List<RouteSchedule>> fetchAllRouteSchedules() async {
  final snapshot = await busesCollection.get();
  final List<RouteSchedule> routeSchedules = [];

  for (var doc in snapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;
    for (var entry in data.entries) {
      final routeName = entry.key;
      final routeData = entry.value;
      print("Route Name: $routeName");
      print("Route Data: $routeData");

      if (routeData != null) {
        final downTrips = List<Map<String, dynamic>>.from(routeData['downTrip_buses'] ?? []);
        final upTrips = List<Map<String, dynamic>>.from(routeData['upTrip_buses'] ?? []);
        routeSchedules.add(RouteSchedule(
          routeName: routeName,
          downTripBuses: downTrips,
          upTripBuses: upTrips,
        ));
      }
    }
  }

  return routeSchedules;
}

}

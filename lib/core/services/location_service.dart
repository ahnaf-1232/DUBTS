import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubts/core/models/bus_location_model.dart';
import 'package:dubts/core/services/background_location_service.dart';
import 'package:dubts/core/services/database_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final DatabaseService _databaseService = DatabaseService();
  StreamSubscription<Position>? _positionStreamSubscription;
  String? _currentBusId;

  // Get current position
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return Future.error('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } 

    // Permissions are granted, get position
    return await Geolocator.getCurrentPosition();
  }

  // Start tracking bus location (for bus drivers)
  Future<bool> startTrackingBus(String busId, BuildContext context) async {
    print('Starting foreground tracking for bus: $busId');
    _currentBusId = busId;
    
    // Initialize and start background service
    await BackgroundLocationService.initForegroundTask();
    final started = await BackgroundLocationService.startLocationService(busId, context);
    
    if (!started) {
      // If background service failed, fallback to foreground tracking
      startForegroundTracking(busId);
    }
    
    return true;
  }

  // Start tracking in foreground (fallback)
  void startForegroundTracking(String busId) {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen((Position position) {
      _updateBusLocation(busId, position);
    });
  }

  // Stop tracking location
  Future<void> stopTrackingBus() async {
    // Stop background service
    await BackgroundLocationService.stopLocationService();
    
    // Stop foreground tracking if active
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    
    // Update bus status to inactive
    if (_currentBusId != null) {
      await _updateBusStatusToInactive(_currentBusId!);
    }
    
    _currentBusId = null;
  }

  // Update bus status to inactive
  Future<void> _updateBusStatusToInactive(String busId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('bus_locations')
          .where('busId', isEqualTo: busId)
          .get();
      
      if (snapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('bus_locations')
            .doc(snapshot.docs.first.id)
            .update({'isActive': false});
      }
    } catch (e) {
      print('Error updating bus status: $e');
    }
  }

  // Update bus location
  Future<void> _updateBusLocation(String busId, Position position) async {
    BusLocationModel location = BusLocationModel(
      busId: busId,
      location: GeoPoint(position.latitude, position.longitude),
      heading: position.heading,
      timestamp: DateTime.now(),
      isActive: true,
    );

    await _databaseService.updateBusLocation(location);
  }

  // Check if tracking is active
  Future<bool> isTrackingActive() async {
    return await BackgroundLocationService.isLocationServiceRunning();
  }

  // Calculate distance between two points
  double calculateDistance(GeoPoint point1, GeoPoint point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }
}

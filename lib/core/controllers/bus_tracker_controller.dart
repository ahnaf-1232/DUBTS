import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubts/core/models/bus_location_model.dart';
import 'package:dubts/core/models/bus_model.dart';
import 'package:dubts/core/models/route_schedules.dart';
import 'package:dubts/core/services/database_service.dart';
import 'package:dubts/core/services/location_service.dart';
import 'package:dubts/core/services/notification_service.dart';
import 'package:flutter/material.dart';

class BusTrackerController {
  final DatabaseService _databaseService = DatabaseService();
  final LocationService _locationService = LocationService();
  final NotificationService _notificationService = NotificationService();

  // Get all buses
  Stream<List<BusModel>> get buses => _databaseService.buses;

  // Get buses by route
  Stream<List<BusModel>> getBusesByRoute(String route) =>
      _databaseService.getBusesByRoute(route);

  // Get bus by id
  Future<BusModel?> getBusById(String id) => _databaseService.getBusById(id);

  // Get bus location
  Stream<BusLocationModel?> getBusLocation(String busId) =>
      _databaseService.getBusLocation(busId);

  // Start tracking bus location (for bus drivers)
  Future<bool> startTrackingBus(String busId, BuildContext context) async {
    print('----------------------------------------------------------------------------------------');
    print('Starting foreground tracking for bus: $busId');
    return await _locationService.startTrackingBus(busId, context);
  }

  // Stop tracking bus location
  Future<void> stopTrackingBus() async {
    await _locationService.stopTrackingBus();
  }

  // Check if tracking is active
  Future<bool> isTrackingActive() async {
    return await _locationService.isTrackingActive();
  }

  // Add new bus
  Future<void> addBus(BusModel bus) => _databaseService.addBus(bus);

  // Update bus
  Future<void> updateBus(BusModel bus) => _databaseService.updateBus(bus);

  // Delete bus
  Future<void> deleteBus(String busId) => _databaseService.deleteBus(busId);

  // Calculate distance to bus
  Future<double> calculateDistanceToBus(String busId) async {
    try {
      // Get current position
      final currentPosition = await _locationService.getCurrentPosition();
      final currentGeoPoint =
          GeoPoint(currentPosition.latitude, currentPosition.longitude);

      // Get bus location
      final busLocationSnapshot = await FirebaseFirestore.instance
          .collection('bus_locations')
          .where('busId', isEqualTo: busId)
          .get();

      if (busLocationSnapshot.docs.isEmpty) {
        return double.infinity;
      }

      final busLocation =
          BusLocationModel.fromMap(busLocationSnapshot.docs.first.data());

      // Calculate distance
      return _locationService.calculateDistance(
          currentGeoPoint, busLocation.location);
    } catch (e) {
      print('Error calculating distance to bus: $e');
      return double.infinity;
    }
  }

  // Notify when bus is approaching
  Future<void> notifyWhenBusApproaching(
      String busId, String busName, double thresholdDistance) async {
    Timer.periodic(const Duration(minutes: 1), (timer) async {
      final distance = await calculateDistanceToBus(busId);

      if (distance <= thresholdDistance) {
        await _notificationService.showNotification(
          id: 1,
          title: 'Bus Approaching',
          body: '$busName is about ${distance.toStringAsFixed(0)} meters away',
        );
        timer.cancel();
      }
    });
  }

  Future<List<RouteSchedule>> fetchAllRouteSchedules() async {
    return _databaseService.fetchAllRouteSchedules();
  }
}

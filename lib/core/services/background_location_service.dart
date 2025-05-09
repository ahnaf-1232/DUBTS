import 'dart:async';
import 'dart:isolate';

import 'package:dubts/core/models/bus_location_model.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// The callback function should always be a top-level function
@pragma('vm:entry-point')
void startCallback() {
  // The port is used to communicate with the main isolate.
  FlutterForegroundTask.setTaskHandler(LocationTaskHandler());
}

class LocationTaskHandler extends TaskHandler {
  SendPort? _sendPort;
  Timer? _timer;
  String? _busId;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter? sendPort) async {
    _sendPort = sendPort as SendPort?;

    // Get the bus ID from shared preferences
    final prefs = await FlutterForegroundTask.getData<String>(key: 'busId');
    _busId = prefs;

    // Start periodic location updates
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await _updateLocation();
    });
  }

  Future<void> _updateLocation() async {
    try {
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Send location to main isolate
      _sendPort?.send({
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      // Update notification content
      await FlutterForegroundTask.updateService(
        notificationTitle: 'Bus Koi is tracking your location',
        notificationText: 'Location: ${position.latitude}, ${position.longitude}',
      );

      // Update location in Firestore if busId is available
      if (_busId != null) {
        await _updateBusLocation(_busId!, position);
      }
    } catch (e) {
      print('Error updating location: $e');
    }
  }

  Future<void> _updateBusLocation(String busId, Position position) async {
    try {
      final location = BusLocationModel(
        busId: busId,
        location: GeoPoint(position.latitude, position.longitude),
        heading: position.heading,
        timestamp: DateTime.now(),
        isActive: true,
      );

      // Find if there's an existing document for this bus
      final existingDocs = await _firestore
          .collection('bus_locations')
          .where('busId', isEqualTo: busId)
          .get();

      if (existingDocs.docs.isNotEmpty) {
        // Update existing document
        await _firestore
            .collection('bus_locations')
            .doc(existingDocs.docs.first.id)
            .update(location.toMap());
      } else {
        // Create new document
        await _firestore.collection('bus_locations').add(location.toMap());
      }
    } catch (e) {
      print('Error updating bus location in Firestore: $e');
    }
  }

  Future<void> onEvent(DateTime timestamp, SendPort? sendPort) async {
    // This method will be called every 5 minutes (default)
    await _updateLocation();
  }

  @override
  Future<void> onDestroy(DateTime timestamp, bool isUserInitiated) async {
    // Cancel timer
    _timer?.cancel();

    // Update bus status to inactive if busId is available
    if (_busId != null) {
      try {
        final existingDocs = await _firestore
            .collection('bus_locations')
            .where('busId', isEqualTo: _busId)
            .get();

        if (existingDocs.docs.isNotEmpty) {
          await _firestore
              .collection('bus_locations')
              .doc(existingDocs.docs.first.id)
              .update({'isActive': false});
        }
      } catch (e) {
        print('Error updating bus status: $e');
      }
    }

    // Send final event to the main isolate
    _sendPort?.send('onDestroy');
  }

  void onButtonPressed(String id) {
    // Handle notification button press
    if (id == 'stopTracking') {
      FlutterForegroundTask.stopService();
    }
  }

  @override
  void onNotificationPressed() {
    // Send notification pressed event to main isolate
    _sendPort?.send('onNotificationPressed');
  }
  
  @override
  void onRepeatEvent(DateTime timestamp) {
    // TODO: implement onRepeatEvent
  }
}

class BackgroundLocationService {
  static ReceivePort? _receivePort;

  // Initialize foreground task
  static Future<void> initForegroundTask() async {
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'bus_koi_location_tracking',
        channelName: 'Location Tracking Service',
        channelDescription: 'This notification appears when the app is tracking your location.',
        channelImportance: NotificationChannelImportance.HIGH,
        priority: NotificationPriority.HIGH,
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: true,
        playSound: false,
      ),
      foregroundTaskOptions: ForegroundTaskOptions(
        autoRunOnBoot: false,
        allowWakeLock: true,
        allowWifiLock: true,
        eventAction: ForegroundTaskEventAction.repeat(5 * 1000),
      ),
    );
  }

  // Start location tracking service
  static Future<bool> startLocationService(String busId) async {
    // Store busId in shared preferences
    await FlutterForegroundTask.saveData(key: 'busId', value: busId);

    // Check if the service is already running
    final isRunning = await FlutterForegroundTask.isRunningService;
    if (isRunning) {
      return true;
    }

    // Request permission
    final allowed = await _requestPermission();
    if (!allowed) {
      return false;
    }

    // Start foreground service
    _receivePort = (await FlutterForegroundTask.startService(
      notificationTitle: 'Bus Koi is tracking your location',
      notificationText: 'Initializing location tracking...',
      callback: startCallback,
    )) as ReceivePort?;

    // Listen to events from the background isolate
    _receivePort?.listen((message) {
      if (message is Map<String, dynamic>) {
        // Handle location update
        print('Location update: ${message['latitude']}, ${message['longitude']}');
      } else if (message is String) {
        if (message == 'onNotificationPressed') {
          // Handle notification press - bring app to foreground
          FlutterForegroundTask.launchApp();
        }
      }
    });

    return true;
  }

  // Stop location tracking service
  static Future<void> stopLocationService() async {
    await FlutterForegroundTask.stopService();
    _receivePort?.close();
    _receivePort = null;
  }

  // Check if the service is running
  static Future<bool> isLocationServiceRunning() async {
    return await FlutterForegroundTask.isRunningService;
  }

  // Request necessary permissions
  static Future<bool> _requestPermission() async {
    // Check and request location permission
    final locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      final permissionResult = await Geolocator.requestPermission();
      if (permissionResult == LocationPermission.denied ||
          permissionResult == LocationPermission.deniedForever) {
        return false;
      }
    }

    // Check and request notification permission
    if (await FlutterForegroundTask.canDrawOverlays) {
      return true;
    } else {
      final permissionResult = await FlutterForegroundTask.openSystemAlertWindowSettings();
      return permissionResult;
    }
  }
}

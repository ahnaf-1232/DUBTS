import 'package:dubts/services/firebaseService.dart';
import 'package:dubts/services/locationService.dart';
import 'package:latlong2/latlong.dart';

class BusTrackerController {
  final String busName;
  final String busCode;
  final String deviceId;
  final LocationService locationService;
  final FirebaseService firebaseService;

  final Function(LatLng)? onLocationUpdated; // ✅ Add this

  BusTrackerController({
    required this.busName,
    required this.busCode,
    required this.deviceId,
    required this.locationService,
    required this.firebaseService,
    this.onLocationUpdated, // ✅ Receive callback
  });

  void startTracking() {
    locationService.getLocationStream().listen((location) {
      final latLng = LatLng(location.latitude, location.longitude);
      onLocationUpdated?.call(latLng); // ✅ Notify the widget
      firebaseService.updateBusLocation(
        busName,
        busCode,
        deviceId,
        location,
      );
    });
  }

  void stopTracking() {
    locationService.stop();
  }
}

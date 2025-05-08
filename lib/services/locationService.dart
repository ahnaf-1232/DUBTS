import 'package:dubts/models/busLocation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<BusLocation?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    return BusLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      altitude: position.altitude,
      speed: position.speed,
      bearing: position.heading,
      timestamp: DateTime.now(),
    );
  }

  Stream<BusLocation> getLocationStream() {
    print("Starting location stream...");
    return Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // meters before update
      ),
    ).map((position) {
      return BusLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
        altitude: position.altitude,
        speed: position.speed,
        bearing: position.heading,
        timestamp: DateTime.now(),
      );
    });
  }

  void stop() {
    // Optional: cleanup if needed
  }
}

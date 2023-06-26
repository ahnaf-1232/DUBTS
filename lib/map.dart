import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class MapTracker extends StatefulWidget {
  const MapTracker({Key? key}) : super(key: key);

  @override
  _MapTrackerState createState() => _MapTrackerState();
}

class _MapTrackerState extends State<MapTracker> {
  late MapController _mapController;
  Stream<LatLng>? _locationStream;
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startLocationTracking();
  }

  Future<void> _startLocationTracking() async {
    final LocationPermission permission = await _getLocationPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle the case when the user denies location permission
      return;
    }

    setState(() {
      _locationStream = Geolocator.getPositionStream().map((position) {
        return LatLng(position.latitude, position.longitude);
      });
    });
  }

  Future<LocationPermission> _getLocationPermission() async {
    if (await Permission.location.isGranted) {
      return LocationPermission.always;
    } else {
      final PermissionStatus status = await Permission.location.request();
      return status.isGranted ? LocationPermission.always : LocationPermission.denied;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder<LatLng>(
          stream: _locationStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _currentLocation = snapshot.data;
              _mapController.move(_currentLocation!, 13.5);
            }

            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: _currentLocation ?? LatLng(51.509364, -0.128928),
                zoom: 9.2,
              ),
              nonRotatedChildren: [
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                        Uri.parse('https://openstreetmap.org/copyright'),
                      ),
                    ),
                  ],
                ),
              ],
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: _currentLocation ?? LatLng(51.509364, -0.128928),
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 40.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

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
  LatLng? _currentLocation;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlutterMap(
        options: MapOptions(
          center:
              _currentLocation ?? LatLng(23.6850, 90.3563), // Centered on Dhaka
          zoom: 8.0, // Initial zoom level
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', // OpenStreetMap provider
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: _currentLocation != null
                ? [
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: _currentLocation!,
                      builder: (ctx) =>
                          Icon(Icons.location_on, color: Colors.red),
                    ),
                  ]
                : [],
          ),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:dubts/services/firebaseService.dart';
import 'package:dubts/services/locationService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapTrackerWidget extends StatefulWidget {
  final String busName;
  final String busCode;
  final String deviceId;
  final String busTime;

  const MapTrackerWidget({
    required this.busName,
    required this.busCode,
    required this.deviceId,
    required this.busTime,
  });

  @override
  _MapTrackerWidgetState createState() => _MapTrackerWidgetState();
}

class _MapTrackerWidgetState extends State<MapTrackerWidget> {
  final LocationService _locationService = LocationService();
  final FirebaseService _firebaseService = FirebaseService();

  LatLng? _currentPosition;
  late final MapController _mapController;
  StreamSubscription? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _subscribeToLocationStream();
  }

  void _subscribeToLocationStream() {
    _locationSubscription = _locationService.getLocationStream().listen((location) {
      final pos = LatLng(location.latitude, location.longitude);

      setState(() {
        _currentPosition = pos;
      });

      // Send to Firebase
      _firebaseService.updateBusLocation(
        widget.busName,
        widget.busCode,
        widget.deviceId,
        location,
      );

      // Safely move the map after the widget is built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _mapController.move(pos, _mapController.camera.zoom);
        }
      });
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _locationService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentPosition != null
          ? FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentPosition!,
                initialZoom: 16,
                maxZoom: 18,
                minZoom: 2.6,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 55.0,
                      point: _currentPosition!,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Container(
                                margin: EdgeInsets.all(10.0),
                                padding: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.red.shade900,
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      widget.busName,
                                      textScaleFactor: 3,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '(${widget.busCode})',
                                      textScaleFactor: 3,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 25.0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

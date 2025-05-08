import 'dart:async';
import 'package:dubts/services/firebaseService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../shared/loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseService _firebaseService = FirebaseService();
  late final MapController _mapController;
  List<Marker> _markers = [];
  StreamSubscription<List<Marker>>? _markerSubscription;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startListeningToBusMarkers();
  }

  void _startListeningToBusMarkers() {
    _markerSubscription = _firebaseService.getBusMarkersStream().listen((markerList) {
      if (mounted) {
        setState(() {
          _markers = markerList;
          _loading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _markerSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Loading()
        : Scaffold(
            body: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(23.7350, 90.3908),
                initialZoom: 10.6,
                minZoom: 2.6,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
          );
  }
}

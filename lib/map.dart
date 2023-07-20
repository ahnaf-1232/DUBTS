import 'dart:async';

import 'package:dubts/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class MapTracker extends StatefulWidget {
  const MapTracker({Key? key}) : super(key: key);

  @override
  _MapTrackerState createState() => _MapTrackerState();
}

class _MapTrackerState extends State<MapTracker> {
  final AuthService _auth = AuthService();
  late MapController _mapController;
  Stream<LatLng>? _locationStream;
  FirebaseDatabase database = FirebaseDatabase.instance;
  final rtdb = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://dubts-a851d-default-rtdb.firebaseio.com/');
  late DatabaseReference ref = rtdb.ref();
  late final center;
  StreamSubscription<Position>? _locationSubscription;
  late var timer;


  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startLocationTracking();
    new Timer.periodic(Duration(seconds: 60), (Timer t) {
      if (!mounted) {
        timer.cancel();
      } else {
        setState(() {});
      }
    });
  }

  Future<void> _startLocationTracking() async {
    final LocationPermission permission = await _getLocationPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle the case when the user denies location permission
      return;
    }

    void pushToDatabase(double latitude, double longitude) {
      Map<String, double> location = {
        'lat': latitude,
        'lng': longitude,
      };
      // print('UserInfo:' + _auth.user.toString());

      String busName = 'Baishakhi';
      String busCode = '3610';
      DatabaseReference locationRef = ref.child('location').child(busName).child(busCode);
      locationRef.set(location);
    }

    _locationSubscription = Geolocator.getPositionStream().listen((position) {
      pushToDatabase(position.latitude, position.longitude);
      if(this.mounted) {
          setState(() {
            _locationStream = Stream.value(LatLng(position.latitude, position.longitude));
          });
      }
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }


  Future<LocationPermission> _getLocationPermission() async {
    if (await Permission.location.isGranted) {
      return LocationPermission.always;
    } else {
      final PermissionStatus status = await Permission.location.request();
      if (status.isGranted) {
        final PermissionStatus backgroundStatus = await Permission.locationWhenInUse.request();
        if (backgroundStatus.isGranted) {
          return LocationPermission.always;
        }
      }
      return LocationPermission.denied;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Profile'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person_2_rounded),
              label: Text('logout'),
              onPressed: () async {
                await _auth.logOut();
                Navigator.pop(context);
                Navigator.pop(context);
                // await FirebaseAuth.instance.signOut();
              },
            )
          ],
        ),
        body: StreamBuilder<LatLng>(
          stream: _locationStream,
          builder: (context, snapshot) {
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(23.6850, 90.3563),
                zoom: 7,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.app',
                ),
                MarkerLayer(
                  markers: [
                    if (snapshot.hasData)
                      Marker(
                        width: 40.0,
                        height: 40.0,
                        point: snapshot.data!,
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

  @override
  void setState(VoidCallback fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }
}
import 'dart:async';

import 'package:dubts/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:carp_background_location/carp_background_location.dart';

class MapTracker extends StatefulWidget {
  const MapTracker({Key? key}) : super(key: key);

  @override
  _MapTrackerState createState() => _MapTrackerState();
}
enum LocationStatus { UNKNOWN, INITIALIZED, RUNNING, STOPPED }

class _MapTrackerState extends State<MapTracker> {
  final AuthService _auth = AuthService();
  late MapController _mapController;
  FirebaseDatabase database = FirebaseDatabase.instance;
  final rtdb = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: 'https://dubts-a851d-default-rtdb.firebaseio.com/');
  late DatabaseReference ref = rtdb.ref();
  late final center;
  late var timer;

  String busName = '';
  String busCode = '';

  StreamSubscription<LocationDto>? locationSubscription;
  LocationStatus _status = LocationStatus.UNKNOWN;
  LocationDto? _lastLocation;
  Stream<LatLng>? _locationStream;


  @override
  void initState() {
    super.initState();

    LocationManager().interval = 1;
    LocationManager().distanceFilter = 0;
    LocationManager().notificationTitle = 'Dhaka University Bus Tracking System';
    LocationManager().notificationMsg = 'Your location is being tracked.';

    _status = LocationStatus.INITIALIZED;

    _mapController = MapController();

    start();
  }

  void pushToDatabase(double latitude, double longitude) {
    Map<String, double> location = {
      'lat': latitude,
      'lng': longitude,
    };

    busName = 'Khanika';
    busCode = '3410';
    DatabaseReference locationRef = ref.child('location').child(busName).child(busCode);
    locationRef.set(location);
  }

  /// Tries to ask for "location always" permissions from the user.
  /// Returns `true` if successful, `false` otherwise.
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

  Future<bool> askForNotificationPermission() async {
    bool granted = await Permission.notification.isGranted;

    if (!granted) {
      granted = await Permission.notification.request() == PermissionStatus.granted;
    }

    return granted;
  }



  void getCurrentLocation() async =>
      onData(await LocationManager().getCurrentLocation());

  void onData(LocationDto location) {
    print('>> $location');
    if(this.mounted) {
      setState(() {
        _lastLocation = location;
        _locationStream = Stream.value(LatLng(_lastLocation!.latitude, _lastLocation!.longitude));
      });
      pushToDatabase(location.latitude, location.longitude);
    }
  }

  void start() async {
    final LocationPermission permission = await _getLocationPermission();
    // ask for location permissions, if not already granted
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      // Handle the case when the user denies location permission
      return;
    }

    // ask for notification permissions, if not already granted
    // if (!await askForNotificationPermission())
    //   return;

    locationSubscription?.cancel();
    locationSubscription = LocationManager().locationStream.listen(onData);
    await LocationManager().start();
    setState(() {
      _status = LocationStatus.RUNNING;
    });
  }

  @override
  void dispose(){
    super.dispose();
    locationSubscription!.cancel();
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
        resizeToAvoidBottomInset: false,
        body: StreamBuilder<LatLng>(
          stream: _locationStream,
          builder: (context, snapshot) {
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(23.6850, 90.3563),
                zoom: 7,
                maxZoom: 18,
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
                        height: 55.0,
                        point: snapshot.data!,
                        builder: (ctx) => Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 6.0),
                              Text(
                                '$busName ($busCode)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),

                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 30.0,
                              ),
                            ],
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
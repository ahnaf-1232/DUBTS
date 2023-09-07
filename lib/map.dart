import 'dart:async';

import 'package:background_location/background_location.dart';
import 'package:dubts/services/auth.dart';
import 'package:dubts/shared/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class MapTracker extends StatefulWidget {
  final String busName;
  final String busCode;
  final String deviceID;

  const MapTracker(
      {required this.busName, required this.busCode, required this.deviceID});

  @override
  _MapTrackerState createState() => _MapTrackerState();
}

class _MapTrackerState extends State<MapTracker> with WidgetsBindingObserver {
  final AuthService _auth = AuthService();

  FirebaseDatabase database = FirebaseDatabase.instance;
  final rtdb = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://dubts-a851d-default-rtdb.firebaseio.com/');
  late DatabaseReference ref = rtdb.ref();
  Completer<void> _appCloseCompleter = Completer<void>();

  late MapController _mapController;

  double latitude = 0.0;
  double longitude = 0.0;
  bool isLocationAvailable = false;
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    start_tracking();
    _mapController = MapController();
  }

  void updateLocationData(double latitude, double longitude) {
    Map<String, double> location = {
      'lat': latitude,
      'lng': longitude,
    };

    String id = widget.deviceID.replaceAll('.', '');

    print('device ID: ${widget.deviceID}');

    DatabaseReference locationRef = ref
        .child('location')
        .child(widget.busName)
        .child(widget.busCode)
        .child(id);
    locationRef.set(location);
  }

  void printLocationData() {
    if (kDebugMode) {
      print('''\n
                        Latitude:  $latitude
                        Longitude: $longitude
                        Altitude: $altitude
                        Accuracy: $accuracy
                        Bearing:  $bearing
                        Speed: $speed
                        Time: $time
                      ''');
    }
  }

  void setNotification(String address) async {
    await BackgroundLocation.setAndroidNotification(
      title: 'Du Bus Tracker',
      message: 'Your bus is now in $address',
      icon: '@mipmap/ic_launcher',
    );
  }

  Future<String> getAddress(lat, lng) async {
    List<Placemark> placeMarks =
        await placemarkFromCoordinates(latitude, longitude);
    Placemark firstPlaceMark = placeMarks.first;
    String street = firstPlaceMark.street ?? 'Unknown Place';
    String subLocality = firstPlaceMark.subLocality ?? '';
    String locality = firstPlaceMark.locality ?? '';

    String address = '$street,$subLocality,$locality';

    return address;
  }

  void getLocation() {
    BackgroundLocation.getLocationUpdates((location) async {
      print(location);
      setState(() {
        if (!isLocationAvailable) {
          isLocationAvailable = true;
        }
        latitude = location.latitude!;
        longitude = location.longitude!;
        accuracy = location.accuracy.toString();
        altitude = location.altitude.toString();
        bearing = location.bearing.toString();
        speed = location.speed.toString();
        time = DateTime.fromMillisecondsSinceEpoch(location.time!.toInt())
            .toString();
      });
      print('Started Tracking');

      String address = await getAddress(latitude, longitude);

      setNotification(address);

      updateLocationData(latitude, longitude);
    });
  }

  void start_tracking() async {
    await BackgroundLocation.startLocationService(distanceFilter: 0);
    getLocation();
  }

  bool isLoggedOut = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: isLocationAvailable
            ? FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(latitude, longitude),
                  zoom: 16,
                  maxZoom: 18,
                  minZoom: 2.6,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        width: 40.0,
                        height: 55.0,
                        point: LatLng(latitude, longitude),
                        builder: (ctx) => Container(
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
                                      borderRadius:
                                          BorderRadius.circular(10.0),
                                      color: Colors.red.shade900,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          '${widget.busName}',
                                          textScaleFactor: 3,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          '(${widget.busCode})',
                                          textScaleFactor: 3,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 25.0,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : Center(child: Loading()),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("App State: $state");
    print("Is app detached? ${state == AppLifecycleState.detached}");
    // await _appCloseCompleter.future;
    if (state == AppLifecycleState.detached) {
      BackgroundLocation.stopLocationService();
      await _auth.logOut(widget.deviceID, widget.busName, widget.busCode);
    }
    // _appCloseCompleter.complete();
  }
}

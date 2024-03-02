import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';

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
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

class MapTracker extends StatefulWidget {
  final String busName;
  final String busCode;
  final String busTime;
  final String deviceID;

  const MapTracker(
      {required this.busName,
      required this.busCode,
      required this.deviceID,
      required this.busTime});

  @override
  _MapTrackerState createState() => _MapTrackerState();
}

class _MapTrackerState extends State<MapTracker> with WidgetsBindingObserver {
  final AuthService _auth = AuthService();
  Timer? _timer;

  FirebaseDatabase database = FirebaseDatabase.instance;
  final rtdb = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://dubts-a851d-default-rtdb.firebaseio.com/');
  late DatabaseReference ref = rtdb.ref();

  Timer? _logoutTimer;

  late MapController _mapController;

  double latitude = 0.0;
  double longitude = 0.0;
  bool isLocationAvailable = false;
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';

  String lastKnownAddress = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // _resetLogoutTimer();
    _startLogoutTimer();
    start_tracking();
    _mapController = MapController();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _pushLocationData();
    });
  }

  void _pushLocationData() async {
    var uri = Uri.parse(
        "http://51.21.35.242:6069/dubts/bus-location/store-location/${widget.busCode}");
    print(uri);
    DateTime now = DateTime.now();
    // Extract date
    String dateOnly = DateFormat('yyyy-MM-dd').format(now);

    // Extract time
    String timeOnly = DateFormat('HH:mm:ss').format(now);

    try {
      var response = await http.put(uri,
          headers: <String, String>{
            'Content-Type': 'application/json', // Specify JSON content type
          },
          body: json.encode({
            "date": dateOnly.toString(),
            "time": timeOnly.toString(),
            "latitude": latitude.toString(),
            "longitude": longitude.toString(),
          }));

      print('Server response: ${response}');
    } catch (e) {
      print('Error making POST request: $e');
    }
  }

  void _startLogoutTimer() async {
    print('Timer Started');

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location service is disabled, prompt the user to enable it
      await Geolocator.openLocationSettings();
      // After the user enables location services, they can return to the app
      // without needing to restart it.
      return;
    }

    print('Location service enabled');

    const logoutDuration = Duration(minutes: 90);
    _logoutTimer = Timer(logoutDuration, () {
      BackgroundLocation.stopLocationService();
      _auth.logOut(widget.deviceID, widget.busName, widget.busCode);
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }

  void updateLocationData(double latitude, double longitude) async {
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
    locationRef.onDisconnect().remove();
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

  Future<void> setNotification(String address) async {
    BackgroundLocation.setAndroidNotification(
      title: 'Tap to view your current location.',
      message: 'Your bus is now in $address.',
      icon: "@mipmap/ic_launcher",
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
      // print(location);
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

      String newAddress = await getAddress(latitude, longitude);

      if (newAddress != lastKnownAddress) {
        lastKnownAddress = newAddress;
        print('Address Changed: $newAddress');

        await setNotification(lastKnownAddress);
      }

      updateLocationData(latitude, longitude);
    });
  }

  void start_tracking() async {
    await BackgroundLocation.startLocationService(
      distanceFilter: 0,
    );
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
                                      borderRadius: BorderRadius.circular(10.0),
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
    _timer?.cancel();
    _logoutTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    BackgroundLocation.stopLocationService();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("App State: $state");
    print("Is app detached? ${state == AppLifecycleState.detached}");
    if (state == AppLifecycleState.resumed) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      print('App resumed. Service enabled: $serviceEnabled');

      if (!serviceEnabled) {
        _auth.logOut(widget.deviceID, widget.busName, widget.busCode);
        Navigator.of(context).pop();
        Navigator.of(context).pop();
      } else {
        WidgetsBinding.instance.addObserver(this);
        // _resetLogoutTimer();
        _startLogoutTimer();
        start_tracking();
        _mapController = MapController();
      }
    } else if (state == AppLifecycleState.detached) {
      BackgroundLocation.stopLocationService();
      Workmanager().registerOneOffTask(
        'data_deletion_task',
        'delete_data',
        initialDelay: Duration(seconds: 0), // Delay before the task runs
        inputData: <String, dynamic>{
          'deviceID': widget.deviceID,
          'busName': widget.busName,
          'busCode': widget.busCode,
        },
      );
      // await _auth.logOut(widget.deviceID, widget.busName, widget.busCode);
    }
  }
}

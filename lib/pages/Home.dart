import 'dart:async';

import 'package:dubts/pages/bus_selector.dart';
import 'package:dubts/pages/schedule.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/auth.dart';
import '../shared/loading.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  late MapController _mapController;
  late DatabaseReference locationRef;
  List<Marker> markers = [];

  // final _formKey = GlobalKey<FormState>();
  bool loading = false;

  StreamSubscription<DatabaseEvent>? _databaseRefSubscription;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _showLoadingScreen();
  }

  Future<void> _showLoadingScreen() async {
    setState(() {
      loading = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() {
        loading = false;
      });
    }
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    final realtimeDB = FirebaseDatabase.instance;
    locationRef = realtimeDB.ref().child('location');
    _databaseRefSubscription = locationRef.onValue.listen((event) {
      if (mounted && event.snapshot.value != null) {
        setState(() {
          markers = _createMarkersFromData(event.snapshot.value as Map);
        });
      } else if (mounted) {
        setState(() {
          markers = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _databaseRefSubscription?.cancel();
    print("Home disposed");
    super.dispose();
  }

  double _calculateMode(Map<double, int> occurrences) {
    // print('entered');
    double modeValue = 0.0;
    int maxCount = 0;

    occurrences.forEach((value, count) {
      if (count > maxCount) {
        modeValue = value;
        maxCount = count;
      }
    });

    return modeValue;
  }

  List<Marker> _createMarkersFromData(Map? data) {
    List<Marker> newMarkers = [];
    if (data != null) {
      data.forEach((key, busName) {
        busName.forEach((busCode, deviceIDs) {
          print(deviceIDs);
          Map<double, int> latitudeOccurrences = {};
          Map<double, int> longitudeOccurrences = {};

          deviceIDs.forEach((deviceID, location) {
            if (location is Map &&
                location.containsKey('lat') &&
                location.containsKey('lng')) {
              double latitude = location['lat'];
              double longitude = location['lng'];

              latitudeOccurrences[latitude] =
                  (latitudeOccurrences[latitude] ?? 0) + 1;
              longitudeOccurrences[longitude] =
                  (longitudeOccurrences[longitude] ?? 0) + 1;
            }
          });

          double modeLatitude = _calculateMode(latitudeOccurrences);
          double modeLongitude = _calculateMode(longitudeOccurrences);

          print('$modeLatitude, $modeLongitude');

          var marker = Marker(
            width: 40.0,
            height: 55.0,
            point: LatLng(modeLatitude, modeLongitude),
            builder: (ctx) => Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 6.0),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Column(
                        children: [
                          FittedBox(
                            fit: BoxFit.fitWidth,
                            child: Container(
                              margin: EdgeInsets.all(10.0),
                              padding: EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.red.shade900,
                              ),
                              child: Column (
                                children: [
                                  Text(
                                    '$key',
                                    textScaleFactor: 3,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '($busCode)',
                                    textScaleFactor: 3,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
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
          );

          newMarkers.add(marker);
        });
      });
    }
    return newMarkers;
  }

  bool isAnonSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : MaterialApp(
            home: Scaffold(
              body: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(23.7350, 90.3908),
                  zoom: 10.6,
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
                    markers: markers,
                  ),
                ],
              ),
            ),
          );
  }
}

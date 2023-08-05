import 'dart:async';

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

  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  StreamSubscription<DatabaseEvent>? _databsaeRefSubscription;

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
    final rtdb = FirebaseDatabase.instance;
    locationRef = rtdb.ref().child('location');
    _databsaeRefSubscription = locationRef.onValue.listen((event) {
      if (mounted && event.snapshot.value != null) {
        setState(() {
          markers = _createMarkersFromData(event.snapshot.value as Map);
        });
      } else {
        setState(() {
          markers = [];
        });
      }
    });
  }

  @override
  void dispose() {
    _databsaeRefSubscription?.cancel();
    super.dispose();
  }

  List<Marker> _createMarkersFromData(Map? data) {
    List<Marker> newMarkers = [];
    if (data != null) {
      data.forEach((key, busName) {
        busName.forEach((busCode, deviceIDs) {
          print(deviceIDs);
          double latitude = 0.0;
          double longitude = 0.0;
          int totalKeys = 0;

          deviceIDs.forEach((deviceID, location) {
            if (location is Map &&
                location.containsKey('lat') &&
                location.containsKey('lng')) {
              latitude += location['lat'];
              longitude += location['lng'];
              totalKeys++;
            }
          });

          print('$latitude, $longitude, $totalKeys');

          latitude = latitude / totalKeys;
          longitude = longitude / totalKeys;

          var marker = Marker(
            width: 40.0,
            height: 55.0,
            point: LatLng(latitude, longitude),
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
                          Text(
                            '$key',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '($busCode)',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : MaterialApp(
            home: Scaffold(
              appBar: AppBar(
                title: Text('Home'),
                backgroundColor: Colors.brown[400],
                elevation: 0.0,
                actions: <Widget>[
                  ElevatedButton(
                    child: Text('Be a guide!'),
                    onPressed: () async {
                      dynamic result = await _auth.signInAnon();
                      if (result == null) {
                        print('error signing in');
                      } else {
                        print('signed in');
                        print(result);
                      }
                    },
                  ),
                ],
              ),
              body: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  center: LatLng(23.6850, 90.3563),
                  zoom: 7,
                  maxZoom: 18,
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

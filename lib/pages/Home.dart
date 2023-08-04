import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../services/auth.dart';

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
  StreamSubscription<DatabaseEvent>? _databsaeRefSubscription;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp();
    final rtdb = FirebaseDatabase.instance;
    locationRef = rtdb.reference().child('location');
    _databsaeRefSubscription = locationRef.onValue.listen((event) {
      if(mounted) {
        setState(() {
          markers = _createMarkersFromData(event.snapshot.value as Map);
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
      data.forEach((key, value) {
        value.forEach((innerKey, innerValue) {
          final lng = innerValue['lng'];
          final lat = innerValue['lat'];
          var marker = Marker(
            width: 40.0,
            height: 55.0,
            point: LatLng(lat, lng),
            builder: (ctx) => Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 6.0),
                  Text(
                    '$key ($innerKey)',
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
          );

          newMarkers.add(marker);
        });
      });
    }
    return newMarkers;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: Icon(Icons.person_2_rounded),
              label: Text('Sign In'),
              onPressed: () async {
                Navigator.pushNamed(context, '/sign_in');
                // await FirebaseAuth.instance.signOut();
              },
            )
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
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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

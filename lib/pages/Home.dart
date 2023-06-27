import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/plugin_api.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late MapController _mapController;
  late Stream<Query> stream;
  FirebaseDatabase database = FirebaseDatabase.instance;
  final rtdb = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://dubts-a851d-default-rtdb.firebaseio.com/');
  late DatabaseReference locationRef = rtdb.ref().child('location');
  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _startGettingLocations();
  }

  Future<void> _startGettingLocations() async {
    final data = await locationRef.get();
    Map location = data.value as Map;
    if (data.exists) {
      print(data.value);
      setState(() {
        location.forEach((key, value) {
          print('Key: $key');
          value.forEach((innerKey, innerValue) {
            final lng = innerValue['lng'];
            final lat = innerValue['lat'];
            var marker = Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(lat, lng),
              builder: (ctx) => Container(
                child: Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            );

            markers.add(marker);
          });
        });
      });
    } else {
      print('No data available.');
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseReference db = FirebaseDatabase.instance.ref().child('location');
    return MaterialApp(
      home: Scaffold(
        body: StreamBuilder(
          stream: locationRef.onValue,
          builder: (context, snapshot) {
            print('FlutterMap builder called');
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
                  markers: markers,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

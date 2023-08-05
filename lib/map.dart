import 'package:background_location/background_location.dart';
import 'package:dubts/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
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

class _MapTrackerState extends State<MapTracker> {
  final AuthService _auth = AuthService();

  FirebaseDatabase database = FirebaseDatabase.instance;
  final rtdb = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://dubts-a851d-default-rtdb.firebaseio.com/');
  late DatabaseReference ref = rtdb.ref();

  late MapController _mapController;

  double latitude = 23.6850;
  double longitude = 90.3563;
  String altitude = 'waiting...';
  String accuracy = 'waiting...';
  String bearing = 'waiting...';
  String speed = 'waiting...';
  String time = 'waiting...';

  @override
  void initState() {
    super.initState();
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

  void deleteLocationData() {
    String id = widget.deviceID.replaceAll('.', '');
    DatabaseReference locationRef = ref
        .child('location')
        .child(widget.busName)
        .child(widget.busCode)
        .child(id);
    locationRef.remove();
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

  void setNotification() async {
    await BackgroundLocation.setAndroidNotification(
      title: 'Background service is running',
      message:
          'Background location in progress. latitude: ${latitude}, longitude: ${longitude}',
      icon: '@mipmap/ic_launcher',
    );
  }

  void getLocation() {
    BackgroundLocation.getLocationUpdates((location) {
      print(location);
      setState(() {
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

      printLocationData();

      setNotification();

      updateLocationData(latitude, longitude);
    });
  }

  void start_tracking() async {
    await BackgroundLocation.startLocationService(distanceFilter: 0);
    getLocation();
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        deleteLocationData();
        return true;
      },
      child: MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(Icons.person_2_rounded),
                  label: const Text('logout'),
                  onPressed: () async {
                    await _auth.logOut();
                    Navigator.of(context).pop();
                    // Navigator.pop(context);
                    // await FirebaseAuth.instance.signOut();
                  },
                )
              ],
            ),
            body: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(latitude, longitude),
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
                  Marker(
                  width: 40.0,
                  height: 55.0,
                  point: LatLng(latitude, longitude),
                  builder: (ctx) => Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 6.0),
                        Text(
                          '${widget.busName} (${widget.busCode})',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 10.0,
                              fontWeight: FontWeight.bold),
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
                    // Marker(
                    //   width: 40.0,
                    //   height: 40.0,
                    //   point: LatLng(latitude, longitude),
                    //   builder: (ctx) => const Icon(
                    //     Icons.location_pin,
                    //     color: Colors.red,
                    //     size: 40.0,
                    //   ),
                    // ),
                  ],
                ),
              ],
            )),
      ),
    );
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    deleteLocationData();
    super.dispose();
  }
}

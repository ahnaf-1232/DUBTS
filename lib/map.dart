import 'package:background_location/background_location.dart';
import 'package:dubts/pages/schedule.dart';
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

class _MapTrackerState extends State<MapTracker> {
  final AuthService _auth = AuthService();

  FirebaseDatabase database = FirebaseDatabase.instance;
  final rtdb = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: 'https://dubts-a851d-default-rtdb.firebaseio.com/');
  late DatabaseReference ref = rtdb.ref();

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

  void setNotification(String address) async {
    await BackgroundLocation.setAndroidNotification(
      title: 'Du Bus Tracker',
      message:
          'Your bus is now in $address',
      icon: '@mipmap/ic_launcher',
    );
  }

  Future<String> getAddress(lat, lng) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(latitude, longitude);
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
        if(!isLocationAvailable) {
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
    return WillPopScope(
      onWillPop: () async {
        deleteLocationData();
        return true;
      },
      child: MaterialApp(
        home: Scaffold(
            appBar: AppBar(
              title: const Text(
                'Tracker',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              elevation: 0.0,
              actions: <Widget>[
                TextButton.icon(
                  icon: const Icon(
                    Icons.schedule,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Schedule',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SchedulePage()), // Replace SchedulePage with the actual name of your schedule page widget
                    );
                  },
                ),
                TextButton.icon(
                  icon: Stack(
                    alignment: Alignment
                        .center, // Center the loading indicator within the icon
                    children: [
                      if (!isLoggedOut)
                        Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                      if (isLoggedOut)
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                    ],
                  ),
                  label: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoggedOut = true; // Set signing in state to true
                    });

                    await _auth.logOut();

                    setState(() {
                      isLoggedOut = false; // Set signing in state back to false
                    });
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
            body: isLocationAvailable?
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                center: LatLng(latitude, longitude),
                zoom: 16,
                maxZoom: 18,
                minZoom: 2.6,
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
            ) :
            Center(child: Loading()),
        ),
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

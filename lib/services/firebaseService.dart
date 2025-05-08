import 'package:dubts/models/busLocation.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class FirebaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final DatabaseReference _locationRef =
      FirebaseDatabase.instance.ref('location');

  Future<void> updateBusLocation(String busName, String busCode,
      String deviceId, BusLocation location) async {
    String id = deviceId.replaceAll('.', '');
    DatabaseReference locationRef =
        _database.child('location/$busName/$busCode/$id');

    await locationRef.set(location.toJson());
    locationRef.onDisconnect().remove();
  }

  Stream<List<Marker>> getBusMarkersStream() {
    return _locationRef.onValue.map((event) {
      final data = event.snapshot.value as Map?;
      List<Marker> markers = [];

      if (data != null) {
        data.forEach((busName, busCodes) {
          if (busCodes is Map) {
            busCodes.forEach((busCode, deviceMap) {
              if (deviceMap is Map) {
                Map<double, int> latCounts = {};
                Map<double, int> lngCounts = {};

                deviceMap.forEach((deviceId, location) {
                  if (location is Map) {
                    final lat =
                        (location['lat'] ?? location['latitude'])?.toDouble();
                    final lng =
                        (location['lng'] ?? location['longitude'])?.toDouble();
                    if (lat != null && lng != null) {
                      latCounts[lat] = (latCounts[lat] ?? 0) + 1;
                      lngCounts[lng] = (lngCounts[lng] ?? 0) + 1;
                    }
                  }
                });

                if (latCounts.isNotEmpty && lngCounts.isNotEmpty) {
                  double modeLat = _getMode(latCounts);
                  double modeLng = _getMode(lngCounts);

                  markers.add(Marker(
                    width: 40.0,
                    height: 55.0,
                    point: LatLng(modeLat, modeLng),
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.red.shade900,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            children: [
                              // Text(
                              //   '$busName',
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              // ),
                              // Text(
                              //   '($busCode)',
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Icon(Icons.location_pin, color: Colors.red, size: 25),
                      ],
                    ),
                  ));
                }
              }
            });
          }
        });
      }

      return markers;
    });
  }

  double _getMode(Map<double, int> map) {
    double mode = 0.0;
    int maxCount = 0;
    map.forEach((val, count) {
      if (count > maxCount) {
        maxCount = count;
        mode = val;
      }
    });
    return mode;
  }
}

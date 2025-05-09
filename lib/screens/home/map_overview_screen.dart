import 'package:dubts/core/controllers/bus_tracker_controller.dart';
import 'package:dubts/core/models/bus_location_model.dart';
import 'package:dubts/core/models/bus_model.dart';
import 'package:dubts/screens/home/bus_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class MapOverviewScreen extends StatefulWidget {
  const MapOverviewScreen({Key? key}) : super(key: key);

  @override
  _MapOverviewScreenState createState() => _MapOverviewScreenState();
}

class _MapOverviewScreenState extends State<MapOverviewScreen> {
  final BusTrackerController _busTrackerController = BusTrackerController();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isLoading = true;
  LatLng _currentPosition = const LatLng(23.8103, 90.4125); // Default to Dhaka
  Map<String, BusModel> _busesMap = {};
  
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadBuses();
  }
  
  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
      
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(_currentPosition, 14),
        );
      }
    } catch (e) {
      print('Error getting current location: $e');
    }
  }
  
  Future<void> _loadBuses() async {
    try {
      // Get all buses
      final busesStream = _busTrackerController.buses;
      
      busesStream.listen((buses) {
        // Create a map of bus ID to bus model for easy lookup
        final busMap = {for (var bus in buses) bus.id: bus};
        
        setState(() {
          _busesMap = busMap;
        });
        
        // Load bus locations
        _loadBusLocations();
      });
    } catch (e) {
      print('Error loading buses: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _loadBusLocations() async {
    try {
      // Get all active bus locations
      final locationsSnapshot = await FirebaseFirestore.instance
          .collection('bus_locations')
          .where('isActive', isEqualTo: true)
          .get();
      
      final Set<Marker> markers = {};
      
      for (final doc in locationsSnapshot.docs) {
        final location = BusLocationModel.fromMap(doc.data());
        final busId = location.busId;
        
        // Skip if we don't have the bus details
        if (!_busesMap.containsKey(busId)) continue;
        
        final bus = _busesMap[busId]!;
        
        // Create marker
        final marker = Marker(
          markerId: MarkerId(busId),
          position: LatLng(
            location.location.latitude,
            location.location.longitude,
          ),
          infoWindow: InfoWindow(
            title: bus.name,
            snippet: 'Route: ${bus.route}',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BusDetailsScreen(bus: bus),
                ),
              );
            },
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        );
        
        markers.add(marker);
      }
      
      setState(() {
        _markers = markers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading bus locations: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentPosition,
              zoom: 14,
            ),
            markers: _markers,
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            mapType: MapType.normal,
            zoomControlsEnabled: false,
            compassEnabled: true,
          ),
          
          // Loading indicator
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          
          // Info card
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.directions_bus,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Active Buses: ${_markers.length}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          color: Colors.red,
                          onPressed: () {
                            setState(() {
                              _isLoading = true;
                            });
                            _loadBusLocations();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tap on a bus marker to view details',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'locate',
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            child: const Icon(Icons.my_location),
            onPressed: () {
              _getCurrentLocation();
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'refresh',
            backgroundColor: Colors.red,
            child: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadBusLocations();
            },
          ),
        ],
      ),
    );
  }
}

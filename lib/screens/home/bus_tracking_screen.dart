import 'dart:async';
import 'package:dubts/core/controllers/bus_tracker_controller.dart';
import 'package:dubts/core/models/bus_location_model.dart';
import 'package:dubts/core/models/bus_model.dart';
import 'package:dubts/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusTrackingScreen extends StatefulWidget {
  final BusModel bus;
  
  const BusTrackingScreen({
    Key? key,
    required this.bus,
  }) : super(key: key);

  @override
  _BusTrackingScreenState createState() => _BusTrackingScreenState();
}

class _BusTrackingScreenState extends State<BusTrackingScreen> with WidgetsBindingObserver {
  final BusTrackerController _busTrackerController = BusTrackerController();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isTracking = false;
  bool _isLoading = false;
  Timer? _locationUpdateTimer;
  StreamSubscription? _locationSubscription;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkTrackingStatus();
    _setupLocationListener();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationUpdateTimer?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Prevent app from closing when tracking is active
    if (state == AppLifecycleState.paused && _isTracking) {
      // App is going to background, show a notification
      print('App going to background while tracking');
    }
  }
  
  Future<void> _checkTrackingStatus() async {
    setState(() {
      _isLoading = true;
    });
    
    final isActive = await _busTrackerController.isTrackingActive();
    
    setState(() {
      _isTracking = isActive;
      _isLoading = false;
    });
  }
  
  void _setupLocationListener() {
    _locationSubscription = _busTrackerController
        .getBusLocation(widget.bus.id)
        .listen((busLocation) {
      if (busLocation != null && busLocation.isActive) {
        _updateMarker(busLocation);
      }
    });
  }
  
  void _updateMarker(BusLocationModel busLocation) {
    final marker = Marker(
      markerId: MarkerId(widget.bus.id),
      position: LatLng(
        busLocation.location.latitude,
        busLocation.location.longitude,
      ),
      infoWindow: InfoWindow(
        title: widget.bus.name,
        snippet: 'Route: ${widget.bus.route}',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
    
    setState(() {
      _markers = {marker};
    });
    
    // Update camera position if controller is available
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(
          LatLng(
            busLocation.location.latitude,
            busLocation.location.longitude,
          ),
        ),
      );
    }
  }
  
  Future<void> _toggleTracking() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_isTracking) {
        // Stop tracking
        await _busTrackerController.stopTrackingBus();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location tracking stopped'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        print('-----------------------------------------------------------------------------');
        // Start tracking
        final success = await _busTrackerController.startTrackingBus(widget.bus.id, context);
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location tracking started'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to start location tracking'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
      
      setState(() {
        _isTracking = !_isTracking;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Tracking ${widget.bus.name}'),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _showInfoDialog();
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Loading()
            : Stack(
                children: [
                  StreamBuilder<BusLocationModel?>(
                    stream: _busTrackerController.getBusLocation(widget.bus.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }
            
                      if (snapshot.connectionState == ConnectionState.waiting && _markers.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        );
                      }
            
                      final busLocation = snapshot.data;
                      
                      if (busLocation == null && _markers.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.location_off,
                                size: 80,
                                color: Colors.red.shade300,
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No location data available',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Start tracking to update your location',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
            
                      // Use existing markers if we have them, otherwise create from busLocation
                      if (_markers.isEmpty && busLocation != null) {
                        final marker = Marker(
                          markerId: MarkerId(widget.bus.id),
                          position: LatLng(
                            busLocation.location.latitude,
                            busLocation.location.longitude,
                          ),
                          infoWindow: InfoWindow(
                            title: widget.bus.name,
                            snippet: 'Route: ${widget.bus.route}',
                          ),
                          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                        );
                        
                        _markers = {marker};
                      }
            
                      return GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: _markers.isNotEmpty
                              ? _markers.first.position
                              : const LatLng(23.8103, 90.4125), // Default to Dhaka
                          zoom: 15,
                        ),
                        markers: _markers,
                        onMapCreated: (controller) {
                          setState(() {
                            _mapController = controller;
                          });
                        },
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        mapType: MapType.normal,
                        zoomControlsEnabled: true,
                        compassEnabled: true,
                      );
                    },
                  ),
                  
                  // Status card
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
                                  _isTracking ? Icons.location_on : Icons.location_off,
                                  color: _isTracking ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _isTracking ? 'Tracking Active' : 'Tracking Inactive',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: _isTracking ? Colors.green : Colors.red,
                                  ),
                                ),
                                const Spacer(),
                                Switch(
                                  value: _isTracking,
                                  activeColor: Colors.green,
                                  onChanged: (_) => _toggleTracking(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Bus: ${widget.bus.name}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Route: ${widget.bus.route}'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.my_location),
          onPressed: () {
            if (_mapController != null && _markers.isNotEmpty) {
              final marker = _markers.first;
              _mapController!.animateCamera(
                CameraUpdate.newLatLng(marker.position),
              );
            }
          },
        ),
      ),
    );
  }
  
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Tracking Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('• When tracking is active, your location will be shared with passengers.'),
            SizedBox(height: 8),
            Text('• Tracking will continue in the background when you close the app.'),
            SizedBox(height: 8),
            Text('• You can stop tracking from the notification or this screen.'),
            SizedBox(height: 8),
            Text('• Battery usage may increase while tracking is active.'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

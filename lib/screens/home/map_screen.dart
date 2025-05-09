import 'dart:async';
import 'package:dubts/core/controllers/bus_tracker_controller.dart';
import 'package:dubts/core/models/bus_location_model.dart';
import 'package:dubts/core/models/bus_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final BusModel bus;
  final GeoPoint initialLocation;
  
  const MapScreen({
    Key? key,
    required this.bus,
    required this.initialLocation,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final BusTrackerController _busTrackerController = BusTrackerController();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _userLocation;
  StreamSubscription? _locationSubscription;
  bool _isFollowingBus = true;
  bool _showingUserLocation = false;
  
  @override
  void initState() {
    super.initState();
    _setInitialMarker();
    _setupLocationListener();
    _getUserLocation();
  }
  
  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }
  
  Future<void> _getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _showingUserLocation = true;
      });
      
      // Add user marker
      _updateMarkers();
    } catch (e) {
      print('Error getting user location: $e');
    }
  }
  
  void _setInitialMarker() {
    final marker = Marker(
      markerId: MarkerId(widget.bus.id),
      position: LatLng(
        widget.initialLocation.latitude,
        widget.initialLocation.longitude,
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
  }
  
  void _setupLocationListener() {
    _locationSubscription = _busTrackerController
        .getBusLocation(widget.bus.id)
        .listen((busLocation) {
      if (busLocation != null && busLocation.isActive) {
        _updateBusMarker(busLocation);
      }
    });
  }
  
  void _updateBusMarker(BusLocationModel busLocation) {
    final busMarker = Marker(
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
    
    _updateMarkers(busMarker);
    
    // Update camera position if following bus
    if (_isFollowingBus && _mapController != null) {
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
  
  void _updateMarkers([Marker? busMarker]) {
    final Set<Marker> newMarkers = {};
    
    // Add bus marker
    if (busMarker != null) {
      newMarkers.add(busMarker);
    } else if (_markers.isNotEmpty) {
      // Use existing bus marker
      final existingBusMarker = _markers.firstWhere(
        (marker) => marker.markerId.value == widget.bus.id,
        orElse: () => Marker(
          markerId: MarkerId(widget.bus.id),
          position: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
        ),
      );
      newMarkers.add(existingBusMarker);
    }
    
    // Add user marker if available
    if (_userLocation != null && _showingUserLocation) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _userLocation!,
          infoWindow: const InfoWindow(
            title: 'Your Location',
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    }
    
    setState(() {
      _markers = newMarkers;
    });
  }
  
  void _toggleUserLocation() {
    setState(() {
      _showingUserLocation = !_showingUserLocation;
    });
    
    _updateMarkers();
    
    if (_showingUserLocation && _userLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(_userLocation!),
      );
    }
  }
  
  void _toggleFollowBus() {
    setState(() {
      _isFollowingBus = !_isFollowingBus;
    });
    
    if (_isFollowingBus && _markers.isNotEmpty && _mapController != null) {
      final busMarker = _markers.firstWhere(
        (marker) => marker.markerId.value == widget.bus.id,
        orElse: () => Marker(
          markerId: MarkerId(widget.bus.id),
          position: LatLng(
            widget.initialLocation.latitude,
            widget.initialLocation.longitude,
          ),
        ),
      );
      
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(busMarker.position),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bus.name} Location'),
        backgroundColor: Colors.red,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                widget.initialLocation.latitude,
                widget.initialLocation.longitude,
              ),
              zoom: 15,
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
          
          // Controls
          Positioned(
            top: 16,
            right: 16,
            child: Column(
              children: [
                FloatingActionButton(
                  heroTag: 'follow',
                  backgroundColor: _isFollowingBus ? Colors.red : Colors.white,
                  foregroundColor: _isFollowingBus ? Colors.white : Colors.red,
                  mini: true,
                  child: Icon(_isFollowingBus ? Icons.gps_fixed : Icons.gps_not_fixed),
                  onPressed: _toggleFollowBus,
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'user',
                  backgroundColor: _showingUserLocation ? Colors.red : Colors.white,
                  foregroundColor: _showingUserLocation ? Colors.white : Colors.red,
                  mini: true,
                  child: const Icon(Icons.person_pin_circle),
                  onPressed: _toggleUserLocation,
                ),
                const SizedBox(height: 8),
                FloatingActionButton(
                  heroTag: 'refresh',
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.red,
                  mini: true,
                  child: const Icon(Icons.refresh),
                  onPressed: () {
                    _getUserLocation();
                  },
                ),
              ],
            ),
          ),
          
          // Bus Info Card
          Positioned(
            bottom: 16,
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
                        Expanded(
                          child: Text(
                            widget.bus.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        StreamBuilder<BusLocationModel?>(
                          stream: _busTrackerController.getBusLocation(widget.bus.id),
                          builder: (context, snapshot) {
                            final isActive = snapshot.hasData && 
                                            snapshot.data != null && 
                                            snapshot.data!.isActive;
                            
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isActive ? Colors.green : Colors.grey,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                isActive ? 'Active' : 'Inactive',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Route: ${widget.bus.route}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Type: ${widget.bus.type}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Fare: ৳${widget.bus.fare.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    StreamBuilder<BusLocationModel?>(
                      stream: _busTrackerController.getBusLocation(widget.bus.id),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data == null) {
                          return const Text(
                            'Last updated: N/A',
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          );
                        }
                        
                        return Text(
                          'Last updated: ${_formatTimestamp(snapshot.data!.timestamp)}',
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
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
            final marker = _markers.firstWhere(
              (marker) => marker.markerId.value == widget.bus.id,
              orElse: () => Marker(
                markerId: MarkerId(widget.bus.id),
                position: LatLng(
                  widget.initialLocation.latitude,
                  widget.initialLocation.longitude,
                ),
              ),
            );
            
            _mapController!.animateCamera(
              CameraUpdate.newLatLng(marker.position),
            );
          }
        },
      ),
    );
  }
  
  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }
}

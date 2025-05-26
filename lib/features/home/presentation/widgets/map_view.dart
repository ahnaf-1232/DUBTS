import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:dubts/features/guide/data/services/guide_service.dart';
import 'package:dubts/features/guide/domain/models/bus_location.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};
  CameraPosition? _currentCameraPosition;
  LocationPermission? _permission;
  bool _isLoading = true;
  bool _isLocationAvailable = false;
  final GuideService _guideService = GuideService();
  
  @override
  void initState() {
    super.initState();
    _checkLocationAvailability();
    _listenToBusLocations();
  }

  void _listenToBusLocations() {
    _guideService.getActiveBusLocations().listen(
      (busLocations) {
        _updateBusMarkers(busLocations);
      },
      onError: (error) {
        print('Error getting bus locations: $error');
      },
    );
  }

  void _updateBusMarkers(List<BusLocation> busLocations) {
    setState(() {
      // Remove old bus markers
      _markers.removeWhere(
        (marker) => marker.markerId.value.startsWith('bus_'),
      );

      // Add new bus markers
      for (var location in busLocations) {
        _markers.add(
          Marker(
            markerId: MarkerId('bus_${location.busCode}_${location.time}'),
            position: LatLng(location.latitude, location.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            infoWindow: InfoWindow(
              title: 'Bus ${location.busCode}',
              snippet: 'Time: ${location.time}',
            ),
          ),
        );
      }
    });
  }

  Future<void> _checkLocationAvailability() async {
    try {
      if (kIsWeb) {
        // Web implementation
        _isLocationAvailable = true;
        _getCurrentLocation();
      } else {
        // Mobile implementation
        _permission = await Geolocator.checkPermission();
        if (_permission == LocationPermission.denied) {
          _permission = await Geolocator.requestPermission();
        }
        if (_permission == LocationPermission.deniedForever) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location permission is permanently denied. Please enable it in settings.'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }
        _isLocationAvailable = _permission == LocationPermission.whileInUse || _permission == LocationPermission.always;
        if (_isLocationAvailable) {
          _getCurrentLocation();
        }
      }
    } catch (e) {
      print('Error checking location availability: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error checking location availability'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      if (kIsWeb) {
        // Fallback location for web
        setState(() {
          _currentCameraPosition = const CameraPosition(
            target: LatLng(23.7772, 90.3995), // Sample location in Dhaka
            zoom: 15,
          );
          _isLoading = false;
        });
        _addBusMarkers();
      } else {
        Position position = await Geolocator.getCurrentPosition();
        setState(() {
          _currentCameraPosition = CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 15,
          );
          _isLoading = false;
        });
        _addLocationMarker(position.latitude, position.longitude);
        _addBusMarkers();
      }
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error getting location'),
          backgroundColor: Colors.red,
        ),
      );
      // Fallback to default location
      setState(() {
        _currentCameraPosition = const CameraPosition(
          target: LatLng(23.7772, 90.3995), // Sample location in Dhaka
          zoom: 15,
        );
        _isLoading = false;
      });
      _addBusMarkers();
    }
  }

  void _addLocationMarker(double latitude, double longitude) {
    setState(() {
      _markers.add(
        Marker(
          markerId: const MarkerId('current_location'),
          position: LatLng(latitude, longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        ),
      );
    });
  }

  void _addBusMarkers() {
    // Add sample bus markers (you'll want to replace these with real bus locations)
    final List<LatLng> busLocations = [
      const LatLng(23.7772, 90.3995), // Sample location in Dhaka
      const LatLng(23.7862, 90.3935),
      const LatLng(23.7802, 90.3975),
    ];

    for (var location in busLocations) {
      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId('bus_${busLocations.indexOf(location)}'),
            position: location,
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            onTap: () {
              // Handle bus marker tap
              print('Bus marker tapped');
            },
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _currentCameraPosition!,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
              backgroundColor: const Color(0xFFE53935),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}
import 'dart:async';
import 'package:dubts/core/services/background_location_service.dart';
import 'package:dubts/core/services/location_service.dart';
import 'package:dubts/shared/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:share_plus/share_plus.dart';
import 'package:app_settings/app_settings.dart';

class UserLocationTrackingScreen extends StatefulWidget {
  const UserLocationTrackingScreen({Key? key}) : super(key: key);

  @override
  _UserLocationTrackingScreenState createState() => _UserLocationTrackingScreenState();
}

class _UserLocationTrackingScreenState extends State<UserLocationTrackingScreen> with WidgetsBindingObserver {
  final LocationService _locationService = LocationService();
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isTracking = false;
  bool _isLoading = false;
  Position? _currentPosition;
  Timer? _locationUpdateTimer;
  String _userId = 'user_${DateTime.now().millisecondsSinceEpoch}'; // Generate a unique ID
  bool _permissionsDenied = false;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkTrackingStatus();
    _getCurrentLocation();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _locationUpdateTimer?.cancel();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Prevent app from closing when tracking is active
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground, check permissions again
      _checkPermissions();
    }
  }
  
  Future<void> _checkPermissions() async {
    final canDrawOverlays = await FlutterForegroundTask.canDrawOverlays;
    
    if (!canDrawOverlays && _isTracking) {
      setState(() {
        _permissionsDenied = true;
      });
    } else {
      setState(() {
        _permissionsDenied = false;
      });
    }
  }
  
  Future<void> _checkTrackingStatus() async {
    setState(() {
      _isLoading = true;
    });
    
    final isActive = await BackgroundLocationService.isLocationServiceRunning();
    
    setState(() {
      _isTracking = isActive;
      _isLoading = false;
    });
    
    await _checkPermissions();
  }
  
  Future<void> _getCurrentLocation() async {
    try {
      final position = await _locationService.getCurrentPosition();
      
      setState(() {
        _currentPosition = position;
      });
      
      _updateMarker(position);
      
      // Center map on current position
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(
            LatLng(position.latitude, position.longitude),
            15,
          ),
        );
      }
    } catch (e) {
      print('Error getting current location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _updateMarker(Position position) {
    final marker = Marker(
      markerId: const MarkerId('current_location'),
      position: LatLng(position.latitude, position.longitude),
      infoWindow: const InfoWindow(
        title: 'Your Location',
        snippet: 'This is your current location',
      ),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
    
    setState(() {
      _markers = {marker};
      _currentPosition = position;
    });
  }
  
  Future<void> _toggleTracking() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      if (_isTracking) {
        // Stop tracking
        await BackgroundLocationService.stopLocationService();
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location tracking stopped'),
            backgroundColor: Colors.red,
          ),
        );
        
        // Cancel timer
        _locationUpdateTimer?.cancel();
        _locationUpdateTimer = null;
      } else {
        // Start tracking
        final success = await BackgroundLocationService.startLocationService(_userId, context);
        
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Location tracking started'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Start periodic location updates for the map
          _locationUpdateTimer = Timer.periodic(
            const Duration(seconds: 10),
            (_) => _getCurrentLocation(),
          );
          
          setState(() {
            _permissionsDenied = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to start location tracking. Please check permissions.'),
              backgroundColor: Colors.red,
            ),
          );
          
          setState(() {
            _permissionsDenied = true;
          });
          
          return;
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
  
  void _shareLocation() {
    if (_currentPosition != null) {
      final latitude = _currentPosition!.latitude;
      final longitude = _currentPosition!.longitude;
      
      // Create Google Maps link
      final googleMapsUrl = 'https://www.google.com/maps?q=$latitude,$longitude';
      
      // Share the location
      Share.share(
        'Check out my current location: $googleMapsUrl',
        subject: 'My Current Location',
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No location available to share'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  void _openAppSettings() async {
    await AppSettings.openAppSettings();
  }
  
  void _showSamsungHelp() async {
    await PermissionService.showSamsungOverlayHelpDialog(context);
  }
  
  @override
  Widget build(BuildContext context) {
    return WithForegroundTask(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Track My Location'),
          backgroundColor: Colors.red,
          actions: [
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareLocation,
              tooltip: 'Share Location',
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: _openAppSettings,
              tooltip: 'App Settings',
            ),
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                _showInfoDialog();
              },
              tooltip: 'Information',
            ),
          ],
        ),
        body: _isLoading
            ? const Loading()
            : Stack(
                children: [
                  // Map
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _currentPosition != null
                          ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
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
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    zoomControlsEnabled: true,
                    compassEnabled: true,
                  ),
                  
                  // Permission warning
                  if (_permissionsDenied)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.red.withOpacity(0.9),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Permission Required',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'The "Appear on top" permission is required for background tracking.',
                            style: TextStyle(color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: _openAppSettings,
                                child: const Text('Open Settings'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.red,
                                ),
                                onPressed: _showSamsungHelp,
                                child: const Text('Samsung Help'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  
                  // Status card
                  Positioned(
                    top: _permissionsDenied ? 120 : 16,
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
                            if (_currentPosition != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                'Latitude: ${_currentPosition!.latitude.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Longitude: ${_currentPosition!.longitude.toStringAsFixed(6)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                  
                  // Action buttons
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.share),
                          label: const Text('Share My Location'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          onPressed: _shareLocation,
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          icon: Icon(_isTracking ? Icons.stop : Icons.play_arrow),
                          label: Text(_isTracking ? 'Stop Tracking' : 'Start Tracking'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isTracking ? Colors.grey : Colors.green,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 45),
                          ),
                          onPressed: _toggleTracking,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.red,
          child: const Icon(Icons.my_location),
          onPressed: _getCurrentLocation,
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
            Text('• When tracking is active, your location will be updated in real-time.'),
            SizedBox(height: 8),
            Text('• Tracking will continue in the background when you close the app.'),
            SizedBox(height: 8),
            Text('• You can stop tracking from the notification or this screen.'),
            SizedBox(height: 8),
            Text('• Battery usage may increase while tracking is active.'),
            SizedBox(height: 8),
            Text('• You can share your location with others using the share button.'),
            SizedBox(height: 16),
            Text('Required Permissions:', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('• Location: To track your current position'),
            Text('• Appear on top: To show notifications when in background'),
            Text('• Notifications: To display tracking status'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
            onPressed: () {
              Navigator.of(context).pop();
              _openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}

class PermissionService {
  static showSamsungOverlayHelpDialog(BuildContext context) {}
}

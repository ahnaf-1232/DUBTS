import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

class PermissionService {
  // Check and request all required permissions
  static Future<bool> checkAndRequestAllPermissions(BuildContext context) async {
    // Check location permission
    final locationPermission = await _checkAndRequestLocationPermission();
    if (!locationPermission) {
      return false;
    }
    
    // Check overlay permission
    final overlayPermission = await _checkAndRequestOverlayPermission(context);
    if (!overlayPermission) {
      return false;
    }
    
    // Check notification permission
    final notificationPermission = await _checkAndRequestNotificationPermission(context);
    if (!notificationPermission) {
      return false;
    }
    
    return true;
  }
  
  // Check and request location permission
  static Future<bool> _checkAndRequestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      return result != LocationPermission.denied && 
             result != LocationPermission.deniedForever;
    }
    
    return permission != LocationPermission.denied && 
           permission != LocationPermission.deniedForever;
  }
  
  // Check and request overlay permission (appear on top)
  static Future<bool> _checkAndRequestOverlayPermission(BuildContext context) async {
    // Check if we can draw overlays
    final hasPermission = await FlutterForegroundTask.canDrawOverlays;
    
    if (!hasPermission) {
      // Show dialog explaining the permission
      final shouldRequest = await _showOverlayPermissionDialog(context);
      
      if (shouldRequest) {
        // Open system settings for overlay permission
        final permissionResult = await FlutterForegroundTask.openSystemAlertWindowSettings();
        
        // Check again after settings opened
        return await FlutterForegroundTask.canDrawOverlays;
      }
      
      return false;
    }
    
    return true;
  }
  
  // Check and request notification permission
  static Future<bool> _checkAndRequestNotificationPermission(BuildContext context) async {
    final status = await Permission.notification.status;
    
    if (status.isDenied || status.isPermanentlyDenied) {
      // Show dialog explaining the permission
      final shouldRequest = await _showNotificationPermissionDialog(context);
      
      if (shouldRequest) {
        if (status.isPermanentlyDenied) {
          // Open app settings if permanently denied
          await AppSettings.openAppSettings();
          return false; // Return false as we can't check the result
        } else {
          // Request permission
          final result = await Permission.notification.request();
          return result.isGranted;
        }
      }
      
      return false;
    }
    
    return true;
  }
  
  // Show dialog for overlay permission
  static Future<bool> _showOverlayPermissionDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Display Over Other Apps'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bus Koi needs permission to display over other apps to show notifications when tracking in the background.',
            ),
            const SizedBox(height: 16),
            const Text(
              'On Samsung devices, you can find this setting at:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Settings > Apps > Bus Koi > Advanced > Appear on top'),
            const Text('OR'),
            const Text('• Settings > Apps > Special access > Appear on top > Bus Koi'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
  
  // Show dialog for notification permission
  static Future<bool> _showNotificationPermissionDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Notification Permission'),
        content: const Text(
          'Bus Koi needs permission to show notifications when tracking your location in the background.',
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(false),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Grant Permission'),
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }
  
  // Show Samsung-specific help dialog for "appear on top" permission
  static Future<void> showSamsungOverlayHelpDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Samsung "Appear on Top" Permission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'On Samsung devices like the S24, you need to manually enable the "Appear on top" permission:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text('Method 1:'),
            const Text('1. Open Settings'),
            const Text('2. Tap on "Apps"'),
            const Text('3. Find and tap on "Bus Koi"'),
            const Text('4. Tap on "Advanced"'),
            const Text('5. Toggle on "Appear on top"'),
            const SizedBox(height: 16),
            const Text('Method 2:'),
            const Text('1. Open Settings'),
            const Text('2. Tap on "Apps"'),
            const Text('3. Tap on the three dots (⋮) in the top right'),
            const Text('4. Tap on "Special access"'),
            const Text('5. Tap on "Appear on top"'),
            const Text('6. Find "Bus Koi" and toggle it on'),
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
            onPressed: () async {
              Navigator.of(context).pop();
              await AppSettings.openAppSettings();
            },
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dubts/map.dart';
import 'package:dubts/pages/Home.dart';
import 'package:dubts/pages/schedule.dart';
import 'package:dubts/services/notificaton.dart';
import 'package:dubts/shared/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;
import '../services/auth.dart';

class Profile extends StatefulWidget {
  final String busName;
  final String busCode;
  final String busTime;

  const Profile({required this.busName, required this.busCode, required this.busTime});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};
  final AuthService _auth = AuthService();
  bool isLoggedOut = false;
  int _selectedIndex = 1;
  String pageName = 'Tracker';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    var deviceData = <String, dynamic>{};

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (defaultTargetPlatform == TargetPlatform.fuchsia) {
        deviceData = <String, dynamic>{
          'Error:': 'Fuchsia platform isn\'t supported'
        };
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });

    print('Serial number: ${_deviceData['id']}');
  }

  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  final physicalSize = ui.window.physicalSize;
  final pixelRatio = ui.window.devicePixelRatio;

  final width = physicalSize.width / pixelRatio;
  final height = physicalSize.height / pixelRatio;

  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
    'screenWidthDp': width,
    'screenHeightDp': height,
    'pixelRatio': pixelRatio,
    'serialNumber': build.serialNumber,
  };
}

  void _onItemTapped(int index, String selectedPageName) {
    setState(() {
      _selectedIndex = index;
      pageName = selectedPageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Move the print statement inside the build method or any other method.
    print('got ${widget.busName}, ${widget.busCode}');

    if (_deviceData['id'] != null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            pageName,
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
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

                await _auth.logOut(
                    _deviceData['id'], widget.busName, widget.busCode);

                await NotificationManager.createNotification(
                    id: 2,
                    title: 'Tracking Stopped',
                    body: 'You logged out from tracker.',
                    locked: false,
                    channel_name: 'logout_notification_channel');

                setState(() {
                  isLoggedOut = false; // Set signing in state back to false
                });
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: <Widget>[
            Home(),
            MapTrackerWidget(
              busName: widget.busName,
              busCode: widget.busCode,
              deviceId: _deviceData['id'],
              busTime: widget.busTime,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          // backgroundColor: Theme.of(context).colorScheme.primary,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
              ),
              label: 'Tracker',
            ),
          ],
          selectedLabelStyle: TextStyle(color: Colors.white),
          unselectedLabelStyle: TextStyle(color: Colors.white),
          selectedIconTheme: IconThemeData(color: Colors.black),
          selectedItemColor: Colors.black,
          currentIndex: _selectedIndex,
          onTap: (int index) {
            String selectedString = (index == 0) ? 'Home' : 'Tracker';
            _onItemTapped(index, selectedString);
          },
        ),
      );
    } else
      return Loading();
  }
}

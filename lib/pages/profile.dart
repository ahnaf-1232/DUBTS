import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dubts/map.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class Profile extends StatefulWidget {
  final String busName;
  final String busCode;

  const Profile({required this.busName, required this.busCode});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> _deviceData = <String, dynamic>{};

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
        deviceData = <String, dynamic>{'Error:': 'Fuchsia platform isn\'t supported'};
      }
    } on PlatformException {
      deviceData = <String, dynamic>{'Error:': 'Failed to get platform version.'};
    }

    if (!mounted) return;

    setState(() {
      _deviceData = deviceData;
    });
    
    print('Serial number: ${_deviceData['id']}');
  }


  Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
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
        'displaySizeInches':
        ((build.displayMetrics.sizeInches * 10).roundToDouble() / 10),
        'displayWidthPixels': build.displayMetrics.widthPx,
        'displayWidthInches': build.displayMetrics.widthInches,
        'displayHeightPixels': build.displayMetrics.heightPx,
        'displayHeightInches': build.displayMetrics.heightInches,
        'displayXDpi': build.displayMetrics.xDpi,
        'displayYDpi': build.displayMetrics.yDpi,
        'serialNumber': build.serialNumber,
      };
    }

    @override
    Widget build(BuildContext context) {
      // Move the print statement inside the build method or any other method.
      print('got ${widget.busName}, ${widget.busCode}');

      return MapTracker(
        busName: widget.busName,
        busCode: widget.busCode,
        deviceID: _deviceData['id'],
      );
    }
}

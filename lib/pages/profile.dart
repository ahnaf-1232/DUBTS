import 'package:dubts/map.dart';
import 'package:flutter/cupertino.dart';

class Profile extends StatefulWidget {
  final String busName;
  final String busCode;

  const Profile({required this.busName, required this.busCode});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    // Move the print statement inside the build method or any other method.
    print('got ${widget.busName}, ${widget.busCode}');

    return MapTracker(busName: widget.busName, busCode: widget.busCode,);
  }
}

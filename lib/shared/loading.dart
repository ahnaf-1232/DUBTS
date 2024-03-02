import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red[50],
      child: const Center(
        child: SpinKitPouringHourGlass(
          color: Colors.red,
          size: 50.0,
        ),
      ),
    );
  }
}

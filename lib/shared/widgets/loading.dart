import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red.shade50,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Shimmer effect
            Shimmer.fromColors(
              baseColor: Colors.red.shade300,
              highlightColor: Colors.red.shade100,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.directions_bus,
                  size: 60,
                  color: Colors.red,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Loading Text with Shimmer effect
            Shimmer.fromColors(
              baseColor: Colors.red.shade300,
              highlightColor: Colors.red.shade100,
              child: const Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

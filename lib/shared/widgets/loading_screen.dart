import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/bus.png',
                height: 120,
                width: 120,
              ),
            ),
            
            const SizedBox(height: 40),
            
            // App Name
            const Text(
              'Bus Koi',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.red,
                letterSpacing: 1.5,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Your Real-time Bus Tracker',
              style: TextStyle(
                fontSize: 16,
                color: Colors.red.shade700,
                letterSpacing: 0.5,
              ),
            ),
            
            const SizedBox(height: 60),
            
            // Loading Animation
            SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                strokeWidth: 6,
                backgroundColor: Colors.red.shade100,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Loading Text
            const Text(
              'Loading...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

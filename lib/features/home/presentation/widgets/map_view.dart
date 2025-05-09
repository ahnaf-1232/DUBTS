import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:flutter/material.dart';

class MapView extends StatelessWidget {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Center(
            child: Icon(
              Icons.map,
              size: screenWidth * 0.25,
              color: Colors.grey.shade400,
            ),
          ),
          Positioned(
            top: 100,
            left: 100,
            child: _buildBusMarker(),
          ),
          Positioned(
            top: 150,
            right: 120,
            child: _buildBusMarker(),
          ),
          Positioned(
            bottom: 80,
            left: 80,
            child: _buildBusMarker(),
          ),
          Positioned(
            top: 120,
            right: 80,
            child: _buildLocationMarker(),
          ),
        ],
      ),
    );
  }

  Widget _buildBusMarker() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Color(0xFFE53935),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.directions_bus,
        color: Colors.white,
        size: 16,
      ),
    );
  }

  Widget _buildLocationMarker() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(
        Icons.my_location,
        color: Colors.white,
        size: 14,
      ),
    );
  }
}
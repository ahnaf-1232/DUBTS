import 'package:cloud_firestore/cloud_firestore.dart';

class BusLocationModel {
  final String busId;
  final GeoPoint location;
  final double heading;
  final DateTime timestamp;
  final bool isActive;

  BusLocationModel({
    required this.busId,
    required this.location,
    required this.heading,
    required this.timestamp,
    required this.isActive,
  });

  factory BusLocationModel.fromMap(Map<String, dynamic> data) {
    return BusLocationModel(
      busId: data['busId'] ?? '',
      location: data['location'] ?? const GeoPoint(0, 0),
      heading: (data['heading'] ?? 0.0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: data['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'busId': busId,
      'location': location,
      'heading': heading,
      'timestamp': Timestamp.fromDate(timestamp),
      'isActive': isActive,
    };
  }

  BusLocationModel copyWith({
    String? busId,
    GeoPoint? location,
    double? heading,
    DateTime? timestamp,
    bool? isActive,
  }) {
    return BusLocationModel(
      busId: busId ?? this.busId,
      location: location ?? this.location,
      heading: heading ?? this.heading,
      timestamp: timestamp ?? this.timestamp,
      isActive: isActive ?? this.isActive,
    );
  }
}

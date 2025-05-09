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

  factory BusLocationModel.fromMap(Map<String, dynamic> map) {
    final loc = Map<String, dynamic>.from(map['location'] ?? {});
    return BusLocationModel(
      busId: map['busId'] ?? '',
      location: GeoPoint(loc['latitude'] ?? 0.0, loc['longitude'] ?? 0.0),
      heading: map['heading']?.toDouble() ?? 0.0,
      timestamp: DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
      isActive: map['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'busId': busId,
      'location': {
        'latitude': location.latitude,
        'longitude': location.longitude,
      },
      'heading': heading,
      'timestamp': timestamp.toIso8601String(),
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

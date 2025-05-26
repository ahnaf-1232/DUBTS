class BusLocation {
  final String busCode;
  final String time;
  final double latitude;
  final double longitude;
  final String guideId;

  BusLocation({
    required this.busCode,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.guideId,
  });

  factory BusLocation.fromJson(Map<String, dynamic> json) {
    return BusLocation(
      busCode: json['bus_code'] ?? '',
      time: json['time'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      guideId: json['guide_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_code': busCode,
      'time': time,
      'latitude': latitude,
      'longitude': longitude,
      'guide_id': guideId,
    };
  }
}

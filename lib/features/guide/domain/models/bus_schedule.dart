class BusSchedule {
  final String busCode;
  final int startingPoint;
  final int endingPoint;
  final String time;

  BusSchedule({
    required this.busCode,
    required this.startingPoint,
    required this.endingPoint,
    required this.time,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      busCode: json['bus_code'] ?? '',
      startingPoint: json['starting_point'] ?? 0,
      endingPoint: json['ending_point'] ?? 0,
      time: json['time'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bus_code': busCode,
      'starting_point': startingPoint,
      'ending_point': endingPoint,
      'time': time,
    };
  }
}

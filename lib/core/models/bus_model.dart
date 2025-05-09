class BusModel {
  final String id;
  final String name;
  final String route;
  final List<BusSchedule> schedules;
  final bool isNearby;

  BusModel({
    required this.id,
    required this.name,
    required this.route,
    required this.schedules,
    this.isNearby = false,
  });

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json['id'],
      name: json['name'],
      route: json['route'],
      schedules: (json['schedules'] as List)
          .map((schedule) => BusSchedule.fromJson(schedule))
          .toList(),
      isNearby: json['isNearby'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'route': route,
      'schedules': schedules.map((schedule) => schedule.toJson()).toList(),
      'isNearby': isNearby,
    };
  }
}

class BusSchedule {
  final String id;
  final String time;
  final String from;
  final String to;
  final bool isCollegeGate;

  BusSchedule({
    required this.id,
    required this.time,
    required this.from,
    required this.to,
    this.isCollegeGate = false,
  });

  factory BusSchedule.fromJson(Map<String, dynamic> json) {
    return BusSchedule(
      id: json['id'],
      time: json['time'],
      from: json['from'],
      to: json['to'],
      isCollegeGate: json['isCollegeGate'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'time': time,
      'from': from,
      'to': to,
      'isCollegeGate': isCollegeGate,
    };
  }
}
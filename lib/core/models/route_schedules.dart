class RouteSchedule {
  final String routeName;
  final List<Map<String, dynamic>> downTripBuses;
  final List<Map<String, dynamic>> upTripBuses;

  RouteSchedule({
    required this.routeName,
    required this.downTripBuses,
    required this.upTripBuses,
  });
}
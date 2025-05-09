import 'package:dubts/core/models/bus_model.dart';

abstract class BusService {
  Future<List<BusModel>> getBuses();
  Future<BusModel> getBusById(String id);
  Future<List<BusModel>> searchBuses(String query);
}

class BusServiceImpl implements BusService {
  @override
  Future<List<BusModel>> getBuses() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Mock data
    return [
      BusModel(
        id: '1',
        name: 'Khan',
        route: 'Shib-Bari to Campus',
        isNearby: true,
        schedules: [
          BusSchedule(
            id: '1',
            time: '05:50 AM',
            from: 'Shib-Bari',
            to: 'Campus',
          ),
          BusSchedule(
            id: '2',
            time: '06:10 AM',
            from: 'Shib-Bari',
            to: 'Campus',
          ),
          BusSchedule(
            id: '3',
            time: '06:10 AM',
            from: 'CollegeGate',
            to: 'Campus',
            isCollegeGate: true,
          ),
        ],
      ),
      BusModel(
        id: '2',
        name: 'Baishaki',
        route: 'Shib-Bari to Campus',
        schedules: [
          BusSchedule(
            id: '1',
            time: '06:40 AM',
            from: 'Shib-Bari',
            to: 'Campus',
          ),
          BusSchedule(
            id: '2',
            time: '07:00 AM',
            from: 'CollegeGate',
            to: 'Campus',
            isCollegeGate: true,
          ),
        ],
      ),
      BusModel(
        id: '3',
        name: 'Hemonto',
        route: 'Shib-Bari to Campus',
        schedules: [
          BusSchedule(
            id: '1',
            time: '07:30 AM',
            from: 'Shib-Bari',
            to: 'Campus',
          ),
        ],
      ),
      BusModel(
        id: '4',
        name: 'Falguni',
        route: 'Shib-Bari to Campus',
        schedules: [
          BusSchedule(
            id: '1',
            time: '08:00 AM',
            from: 'Shib-Bari',
            to: 'Campus',
          ),
        ],
      ),
      BusModel(
        id: '5',
        name: 'Taranga',
        route: 'Shib-Bari to Campus',
        schedules: [
          BusSchedule(
            id: '1',
            time: '08:30 AM',
            from: 'Shib-Bari',
            to: 'Campus',
          ),
        ],
      ),
      BusModel(
        id: '6',
        name: 'Srabon',
        route: 'Shib-Bari to Campus',
        schedules: [
          BusSchedule(
            id: '1',
            time: '09:00 AM',
            from: 'Shib-Bari',
            to: 'Campus',
          ),
        ],
      ),
      BusModel(
        id: '7',
        name: 'Basanta',
        route: 'Shib-Bari to Campus',
        schedules: [
          BusSchedule(
            id: '1',
            time: '09:30 AM',
            from: 'Shib-Bari',
            to: 'Campus',
          ),
        ],
      ),
    ];
  }

  @override
  Future<BusModel> getBusById(String id) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Get all buses
    final buses = await getBuses();
    
    // Find bus by id
    final bus = buses.firstWhere(
      (bus) => bus.id == id,
      orElse: () => throw Exception('Bus not found'),
    );
    
    return bus;
  }

  @override
  Future<List<BusModel>> searchBuses(String query) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    
    // Get all buses
    final buses = await getBuses();
    
    // Filter buses by query
    if (query.isEmpty) {
      return buses;
    }
    
    return buses.where((bus) => 
      bus.name.toLowerCase().contains(query.toLowerCase()) ||
      bus.route.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
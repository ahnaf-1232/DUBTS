import 'package:dubts/core/controllers/bus_tracker_controller.dart';
import 'package:dubts/core/models/route_schedules.dart';
import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final BusTrackerController _busTrackerController = BusTrackerController();
  String _selectedRoute = '';
  final List<String> _routes = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _busTrackerController.fetchAllRouteSchedules(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final schedules = snapshot.data ?? [];

        final routes = schedules.map((e) => e.routeName).toList();

        if (_routes.isEmpty && routes.isNotEmpty) {
          _routes.addAll(routes);
          _selectedRoute = routes.first;
        }

        final selectedSchedule = schedules.firstWhere(
          (r) => r.routeName == _selectedRoute,
          orElse: () => RouteSchedule(routeName: '', downTripBuses: [], upTripBuses: []),
        );

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                value: _selectedRoute.isNotEmpty ? _selectedRoute : null,
                hint: const Text('Select a route'),
                items: routes.map((route) {
                  return DropdownMenuItem<String>(
                    value: route,
                    child: Text(route),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedRoute = value;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: selectedSchedule.downTripBuses.isEmpty &&
                      selectedSchedule.upTripBuses.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_bus, size: 80, color: Colors.red.shade300),
                          const SizedBox(height: 16),
                          const Text(
                            'No trips found for selected route',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ],
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        if (selectedSchedule.downTripBuses.isNotEmpty) ...[
                          const Text("Down Trip",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 8),
                          ...selectedSchedule.downTripBuses.map((trip) => Card(
                                child: ListTile(
                                  leading: const Icon(Icons.arrow_downward,
                                      color: Colors.green),
                                  title: Text("Time: ${trip['time']}"),
                                  subtitle: Text(
                                      "From ${trip['starting_point']} to ${trip['ending_point']}"),
                                ),
                              )),
                          const SizedBox(height: 24),
                        ],
                        if (selectedSchedule.upTripBuses.isNotEmpty) ...[
                          const Text("Up Trip",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const SizedBox(height: 8),
                          ...selectedSchedule.upTripBuses.map((trip) => Card(
                                child: ListTile(
                                  leading:
                                      const Icon(Icons.arrow_upward, color: Colors.blue),
                                  title: Text("Time: ${trip['time']}"),
                                  subtitle: Text(
                                      "From ${trip['starting_point']} to ${trip['ending_point']}"),
                                ),
                              )),
                        ],
                      ],
                    ),
            ),
          ],
        );
      },
    );
  }
}

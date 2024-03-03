import 'package:flutter/material.dart';

class BusHomePage extends StatelessWidget {
  final List<Map<String, dynamic>> busSchedules = [
    {
      'route': 'Route 1',
      'departureTime': '9:00 AM',
      'arrivalTime': '10:30 AM',
      'status': 'On Time',
    },
    {
      'route': 'Route 2',
      'departureTime': '10:15 AM',
      'arrivalTime': '11:45 AM',
      'status': 'Delayed',
    },
    {
      'route': 'Route 3',
      'departureTime': '11:30 AM',
      'arrivalTime': '1:00 PM',
      'status': 'On Time',
    },
    // Add more schedules as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Schedules'),
      ),
      body: ListView.builder(
        itemCount: busSchedules.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              busSchedules[index]['route'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Departure: ${busSchedules[index]['departureTime']}'),
                Text('Arrival: ${busSchedules[index]['arrivalTime']}'),
                Text('Status: ${busSchedules[index]['status']}'),
              ],
            ),
            trailing: busSchedules[index]['status'] == 'Delayed'
                ? Icon(Icons.warning, color: Colors.red)
                : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add functionality to add new bus schedules
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BusHomePage(),
  ));
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
   SchedulePage({super.key});


   @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _showBusDetailsModal(BuildContext context, String busId) async {
    final busDoc = await _firestore.collection('buses').doc(busId).get();

    if (busDoc.exists) {
      final busData = busDoc.data() as Map<String, dynamic>;

      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus Name: ${busData['name']}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text('Route: ${busData['route']}'),
                SizedBox(height: 20),
                Text(
                  'Downtrip Buses:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('buses').doc(busId).collection('downtrip_buses').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final trips = snapshot.data!.docs;

                    return Column(
                      children: trips.map((tripDoc) {
                        final tripData = tripDoc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text('${tripData['starting_point']} to ${tripData['ending_point']}'),
                          subtitle: Text('Time: ${tripData['time']}'),
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Uptrip Buses:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('buses').doc(busId).collection('uptrip_buses').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }

                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    final trips = snapshot.data!.docs;

                    return Column(
                      children: trips.map((tripDoc) {
                        final tripData = tripDoc.data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text('${tripData['starting_point']} to ${tripData['ending_point']}'),
                          subtitle: Text('Time: ${tripData['time']}'),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Schedule', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25,),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white, // Change the color of the back button here
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('buses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final buses = snapshot.data!.docs;

          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text(bus['name']),
                onTap: () => _showBusDetailsModal(context, buses[index].id),
              );
            },
          );
        },
      ),
    );
      // body: ScheduleList(),
  }
}

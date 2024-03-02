import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubts/pages/bus_details_shower.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _showBusDetailsModal(
      BuildContext context, dynamic busData) async {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      isDismissible: false,
      showDragHandle: true,
      enableDrag: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${busData['name']}',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  '***Tap to see trip route.***',
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Text(
                    'Up Trips:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: busData['upTrip_buses'].map<Widget>((tripData) {
                    dynamic route = busData['route'];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BusDetailsViewer(
                                      route: route,
                                      tripData: tripData,
                                      busName: busData['name'],
                                    )));
                      },
                      hoverColor: Colors.grey,
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(
                            tripData['time']!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'From ',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    TextSpan(
                                      text: route[tripData['staring_point']]!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                    TextSpan(
                                      text: ' to ',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    TextSpan(
                                      text: route[tripData['ending_point']]!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: Text(
                    'Down trips:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Column(
                  children: busData['downTrip_buses'].map<Widget>((tripData) {
                    dynamic route = busData['route'];

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BusDetailsViewer(
                                      route: route,
                                      tripData: tripData,
                                      busName: busData['name'],
                                    )));
                      },
                      hoverColor: Colors.grey,
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          title: Text(
                            tripData['time']!,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: 'From ',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    TextSpan(
                                      text: route[tripData['staring_point']]!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                    TextSpan(
                                      text: ' to ',
                                      style: TextStyle(fontSize: 11),
                                    ),
                                    TextSpan(
                                      text: route[tripData['ending_point']]!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Bus Schedule',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
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
        stream: _firestore.collection('bus_schedules').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final buses = snapshot.data!.docs;
          Map<String, dynamic> bus_details = {};
          List<String> bus_names = [];

          for (var document in buses) {
            bus_details = document.data() as Map<String, dynamic>;

            for (var bus_name in bus_details.keys) {
              bus_names.add(bus_name);
            }
          }

          return ListView.builder(
            itemCount: bus_names.length,
            itemBuilder: (BuildContext context, int index) {
              final bus_name = bus_names[index];

              return Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: Container(
                  margin: EdgeInsets.all(9.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.bus_alert_rounded,
                      color: Colors.red.shade700,
                    ),
                    title: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        bus_name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    onTap: () =>
                        _showBusDetailsModal(context, bus_details[bus_name]),
                  ),
                ),
              );
            },
          );

          // return ListView.builder(
          //   itemCount: bus_names.length,
          //   itemBuilder: (context, index) {
          //     final bus_name = bus_names[index];
          //
          //     return ListTile(
          //       title: Text(bus_name),
          //       onTap: () =>
          //           _showBusDetailsModal(context, bus_details[bus_name]),
          //     );
          //   },
          // );
        },
      ),
    );
    // body: ScheduleList(),
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dubts/pages/profile.dart';
import 'package:dubts/shared/loading.dart';
import 'package:flutter/material.dart';
import '../services/notificaton.dart';
import 'package:http/http.dart' as http;

class BusSelector extends StatefulWidget {
  const BusSelector({super.key});

  @override
  State<BusSelector> createState() => _BusSelectorState();
}

class _BusSelectorState extends State<BusSelector> {
  String selectedBusName = '';
  String selectedBusCode = '';
  String selectedBusTime = '';
  bool loading = false;

  Map<String, List<Map<String, String>>> allBusDetails = {};

  @override
  void initState() {
    super.initState();
    _showLoadingScreen();
  }

  Future<void> fetchBusData() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get the bus_schedules collection
      final docSnapshot = await firestore
          .collection('bus_schedules')
          .doc('X4zJH8RxPluvhhHZ8AyM')
          .get();

      final data = docSnapshot.data();

      if (data == null) throw Exception('No data found');

      Map<String, List<Map<String, String>>> selectionData = {};

      data.forEach((busName, busDetails) {
        selectionData[busName] = [];

        final upTrip = (busDetails['upTrip_buses'] ?? []) as List<dynamic>;
        final downTrip = (busDetails['downTrip_buses'] ?? []) as List<dynamic>;

        for (var trip in upTrip) {
          selectionData[busName]?.add({
            "time": trip['time'],
            "code": trip['bus_code'],
          });
        }

        for (var trip in downTrip) {
          selectionData[busName]?.add({
            "time": trip['time'],
            "code": trip['bus_code'],
          });
        }
      });

      if (selectionData.isNotEmpty) {
        final firstBusName = selectionData.keys.first;
        final firstTrip = selectionData[firstBusName]!.first;

        setState(() {
          allBusDetails = selectionData;
          selectedBusName = firstBusName;
          selectedBusCode = firstTrip["code"] ?? "";
          selectedBusTime = firstTrip["time"] ?? "";
        });
      }
    } catch (e) {
      print("Error fetching from Firestore: $e");
    }
  }

  Future<void> _showLoadingScreen() async {
    setState(() {
      loading = true;
    });
    await fetchBusData();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      loading = false;
    });
  }

  Future<void> _sendNotification() async {
    // Your notification logic
    await NotificationManager.createNotification(
      id: 1,
      title: 'Tracking started',
      body: 'Login Successful. We started tracking your location',
      locked: false,
      channel_name: 'login_notification_channel',
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(
                'Bus Selector',
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
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Bus Name: '),
                        SizedBox(
                          width: 30,
                        ),
                        DropdownButton(
                          value: selectedBusName,
                          items: allBusDetails.keys.map((key) {
                            return DropdownMenuItem<String>(
                              value: key,
                              child: Text(key),
                            );
                          }).toList(),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onChanged: (String? selectedValue) {
                            setState(() {
                              selectedBusName = selectedValue!;
                              selectedBusTime =
                                  (allBusDetails[selectedBusName] != null
                                      ? allBusDetails[selectedBusName]![0]
                                          ['time']
                                      : null)!;
                              selectedBusCode =
                                  (allBusDetails[selectedBusName] != null
                                      ? allBusDetails[selectedBusName]![0]
                                          ['code']
                                      : null)!;
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Select Bus Code: '),
                        SizedBox(
                          width: 30,
                        ),
                        DropdownButton(
                          value: selectedBusTime,
                          items: allBusDetails[selectedBusName]!.map((items) {
                            return DropdownMenuItem(
                              value: items["time"],
                              child: Text(items["time"]!),
                            );
                          }).toList(),
                          icon: const Icon(Icons.keyboard_arrow_down),
                          onChanged: (String? selectedValue) {
                            setState(() {
                              // print(allBusDetails[selectedBusName]);
                              allBusDetails[selectedBusName]
                                  ?.forEach((busDetails) {
                                if (busDetails["time"] == selectedValue) {
                                  selectedBusCode = busDetails["code"]!;
                                  selectedBusTime = busDetails["time"]!;
                                }
                              });
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _sendNotification();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Profile(
                                          busName: selectedBusName,
                                          busCode: selectedBusCode,
                                          busTime: selectedBusTime,
                                        )),
                              );
                            },
                            child: Icon(Icons.navigate_next)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

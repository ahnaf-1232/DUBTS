import 'dart:convert';
import 'dart:io';

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
    var uri = Uri.parse(
        "http://51.21.35.242:6069/dubts/bus-details/get-all-bus-data");

    try {
      dynamic response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      Map<String, List<Map<String, String>>> selectionData = {};

      List busDetails = jsonDecode(response.body) as List;

      busDetails.forEach((bus) {
        selectionData[bus["name"]] = [];
        List<dynamic> upTrip_buses = bus["upTripBuses"] as List<dynamic>;

        for (var tripData in upTrip_buses) {
          selectionData[bus["name"]]
              ?.add({"time": tripData['time'], "code": tripData["busCode"]});
        }

        List<dynamic> downTrip_buses = bus['downTripBuses'] as List<dynamic>;

        for (var tripData in downTrip_buses) {
          selectionData[bus["name"]]
              ?.add({"time": tripData['time'], "code": tripData["busCode"]});
        }
      });

      Map<String, dynamic> firstBus = busDetails[0];
      String busName = firstBus["name"];
      List<dynamic> upTripBuses = firstBus["upTripBuses"];
      Map<String, dynamic> firstUpTrip =
          upTripBuses.isNotEmpty ? upTripBuses[0] : {};

      String firstBusCode = firstUpTrip["busCode"] ?? "";
      String firstBusTime = firstUpTrip["time"] ?? "";

      print("Bus Name: ${busName}");
      print("First Bus Code: $firstBusCode");
      print("First Bus Time: $firstBusTime");

      if (mounted) {
        setState(() {
          allBusDetails = selectionData;
          selectedBusName = busName;
          selectedBusCode = firstBusCode;
          selectedBusTime = firstBusTime;
        });
      }
    } catch (e) {
      throw HttpException(e.toString());
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
                                if(busDetails["time"] == selectedValue) {
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

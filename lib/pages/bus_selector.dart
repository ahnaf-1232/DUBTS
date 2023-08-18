import 'package:dubts/pages/profile.dart';
import 'package:flutter/material.dart';
import '../models/bus.dart';
import '../services/databases.dart';

class BusSelector extends StatefulWidget {
  const BusSelector({super.key});

  @override
  State<BusSelector> createState() => _BusSelectorState();
}

class _BusSelectorState extends State<BusSelector> {
  String selectedBusName = 'Baishakhi';
  String selectedBusCode = '3401';
  List<Bus> buses = [];

  Map<String, List<String>> allBusDetails = {};

  @override
  void initState() {
    super.initState();
    fetchBusData();
  }

  Future<void> fetchBusData() async {
    Map<String, List<String>> busDetails = await DatabaseService.fetchBusData();

    if(mounted) {
      setState(() {
        allBusDetails = busDetails;
      });
    }
    
    print(busDetails);

    DatabaseService.printAllBusDetails(allBusDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Selector'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
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
                        selectedBusCode = allBusDetails[selectedBusName]![0];
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
                    value: selectedBusCode,
                    items: allBusDetails[selectedBusName]?.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onChanged: (String? selectedValue) {
                      setState(() {
                        selectedBusCode = selectedValue!;
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Profile(
                                    busName: selectedBusName,
                                    busCode: selectedBusCode,
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

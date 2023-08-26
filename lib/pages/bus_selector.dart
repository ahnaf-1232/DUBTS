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
  String selectedBusName = '';
  String selectedBusCode = '';

  Map<String, List<String>> allBusDetails={};

  @override
  void initState() {
    super.initState();
    fetchBusData();
  }

  Future<void> fetchBusData() async {
    // DatabaseService db=DatabaseService();
    // dynamic busDetails = await db.fetchAllDocuments('bus_schedules');
    Map<String, dynamic> busDetails = await DatabaseService().fetchAllDocuments('bus_schedules') as Map<String, dynamic>;
  Map<String, List<String>> selectionData= {};

    busDetails.forEach((key, value) {
       Map<String,dynamic> buses=busDetails[key] as Map<String,dynamic>;
       selectionData[key] = [];
       List<dynamic> upTrip_buses= buses['upTrip_buses'] as List<dynamic>;

      for(var tripData in upTrip_buses){
        selectionData[key]!.add(tripData['time']);
      }
       List<dynamic> downTrip_buses= buses['downTrip_buses'] as List<dynamic>;

       for(var tripData in downTrip_buses){
         selectionData[key]!.add(tripData['time']);
       }
    });
    print(selectionData);
    String name=selectionData.keys.toList().first;
    List<String>? codes=selectionData[name];

    if(mounted) {
      setState(() {
        allBusDetails = selectionData;
        selectedBusName=selectionData.keys.toList().first;
         selectedBusCode= codes![0];
      });

    };



    // print("Bus details: ");
    // print(busDetails);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Selector', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25,),),
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

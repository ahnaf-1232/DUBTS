import 'package:dubts/services/add_bus_data.dart';
import 'package:dubts/services/databases.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusDetailsAdder extends StatefulWidget {
  const BusDetailsAdder({super.key});

  @override
  State<BusDetailsAdder> createState() => _BusDetailsAdderState();
}

class _BusDetailsAdderState extends State<BusDetailsAdder> {
  @override
  void initState() {
    super.initState();
    DatabaseService().fetchAllDocuments('bus_schedules');
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await AddBusData().addBusDetails();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

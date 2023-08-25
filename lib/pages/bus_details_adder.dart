import 'package:dubts/services/add_bus_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusDetailsAdder extends StatelessWidget {
  const BusDetailsAdder({super.key});

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

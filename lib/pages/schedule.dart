import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Schedule'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
      ),
      // body: ScheduleList(), // Custom widget to display the list of schedules
    );
  }
}

import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';

class BusDetailsViewer extends StatefulWidget {
  final dynamic route;
  final dynamic tripData;
  final String busName;
  BusDetailsViewer(
      {super.key, this.route, this.tripData, required this.busName});

  @override
  State<BusDetailsViewer> createState() => _BusDetailsViewerState();
}

class _BusDetailsViewerState extends State<BusDetailsViewer> {
  List<StepperData> stepperData = []; // Change to late initialization

  @override
  void initState() {
    super.initState();
    _initializeStepperData();
  }

  void _initializeStepperData() {
    if (widget.tripData['staring_point'] < widget.tripData['ending_point']) {
      for (int i = widget.tripData['staring_point'];
          i <= widget.tripData['ending_point'];
          i++) {
        stepperData.add(StepperData(
            title: StepperText(
              widget.route[i],
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            // subtitle: StepperText("Your order has been placed"),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: const Icon(Icons.bus_alert_rounded, color: Colors.white),
            )));
      }
    } else {
      for (int i = widget.tripData['staring_point'];
          i >= widget.tripData['ending_point'];
          i--) {
        stepperData.add(StepperData(
            title: StepperText(
              widget.route[i],
              textStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            // subtitle: StepperText("Your order has been placed"),
            iconWidget: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.all(Radius.circular(30))),
              child: const Icon(Icons.bus_alert_rounded, color: Colors.white),
            )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.busName} Stopages',
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
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 8.0),
              child: AnotherStepper(
                stepperList: stepperData,
                stepperDirection: Axis.vertical,
                iconWidth: 40, // Height that will be applied to all the stepper icons
                iconHeight: 40, // Width that will be applied to all the stepper icons
              ),
            ),
          ),
        )
      ),
    );
  }
}

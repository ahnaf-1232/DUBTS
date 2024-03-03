import 'package:dubts/pages/landing.dart';
import 'package:dubts/pages/bus_details_adder.dart';
// import 'package:dubts/pages/splash.dart';
import 'package:dubts/screens/wrapper.dart';
import 'package:dubts/services/auth.dart';
import 'package:dubts/services/notificaton.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import 'models/user.dart';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await AuthService().deleteLocationData(
        inputData?['deviceID'], inputData?['busName'], inputData?['busCode']);
    return Future.value(true);
  });
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationManager.initialize();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
    systemNavigationBarColor:
        Colors.black, // Background color of the navigation bar
    systemNavigationBarIconBrightness: Brightness.light,
  ));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      value: AuthService().user,
      // initialData: null,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
          useMaterial3: true,
        ),
        home: AnimationPage(),
        // home: BusDetailsAdder(),
      ),
    );
  }
}

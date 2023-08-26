import 'package:dubts/pages/bus_details_adder.dart';
import 'package:dubts/screens/wrapper.dart';
import 'package:dubts/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<CustomUser?>.value(
      value: AuthService().user,
      // initialData: null,
      initialData: null,
      child: MaterialApp(
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
          useMaterial3: true,
        ),
         home: Wrapper(),
         // home: BusDetailsAdder(),
      ),
    );
  }
}
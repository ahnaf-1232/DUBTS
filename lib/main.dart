// import 'package:dubts/pages/Home.dart';
// import 'package:dubts/pages/profile.dart';
import 'package:dubts/pages/profile.dart';
import 'package:dubts/screens/authenticate/authenticate.dart';
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
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/sign_in': (context) => Authenticate(),
          // '/profile': (context) => Profile(busName: '', busCode: ''),
        },
      ),
    );
  }
}
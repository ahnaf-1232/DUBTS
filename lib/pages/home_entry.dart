import 'package:flutter/material.dart';
import 'package:dubts/pages/Home.dart';
import 'package:dubts/pages/bus_selector.dart';
import 'package:dubts/pages/schedule.dart';
import '../services/auth.dart';

class HomeEntry extends StatefulWidget {
  const HomeEntry({super.key});

  @override
  State<HomeEntry> createState() => _HomeEntryState();
}

class _HomeEntryState extends State<HomeEntry> {
  final AuthService _auth = AuthService();
  bool isAnonSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(
              Icons.schedule,
              color: Colors.white,
            ),
            label: const Text(
              'Schedule',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        SchedulePage()), // Replace SchedulePage with the actual name of your schedule page widget
              );
            },
          ), // Add this variable to track signing in state

          TextButton.icon(
            icon: Stack(
              alignment: Alignment
                  .center, // Center the loading indicator within the icon
              children: [
                if (!isAnonSigningIn)
                  Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                if (isAnonSigningIn)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
              ],
            ),
            label: Text(
              'Be a guide!',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              setState(() {
                isAnonSigningIn = true; // Set signing in state to true
              });

              dynamic result = await _auth.signInAnon();

              setState(() {
                isAnonSigningIn =
                false; // Set signing in state back to false
              });

              if (result == null) {
                print('error signing in');
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BusSelector()),
                );
              }
            },
          ),
        ],
      ),
      body: Home(),
    );
  }
}

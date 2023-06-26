import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter App"),
        centerTitle: true,
        backgroundColor: Colors.red.shade400,
      ),
      body: const Text('Hello Buddy.') ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (kDebugMode) {
            print('You Clicked me');
          }
        },
        backgroundColor: Colors.red.shade400,
        child: const Text("Click"),
      ),
    );
  }
}

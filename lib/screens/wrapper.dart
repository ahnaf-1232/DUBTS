import 'package:dubts/core/models/user_model.dart';
import 'package:dubts/screens/authenticate/authenticate.dart';
import 'package:dubts/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel?>(context);
    
    // Return either Home or Authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return const HomeScreen();
    }
  }
}

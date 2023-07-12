import 'package:dubts/models/user.dart';
import 'package:dubts/pages/Home.dart';
// import 'package:dubts/pages/Home.dart';
import 'package:dubts/pages/profile.dart';
import 'package:dubts/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<CustomUser?>(context);
    // print("Users in wrapper: $user");

    if(user == null){
      return const Home();
    }
    else {
      return Profile();
    }

  }
}

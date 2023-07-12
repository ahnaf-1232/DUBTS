import 'package:dubts/screens/authenticate/register.dart';
import 'package:dubts/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});


  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool isSignIn= true;
  void toggleViewFunc(){
    setState(() {
      // print(isSignIn.toString());
      isSignIn= !isSignIn;
      // print(isSignIn.toString());
    });
  }
  @override
  Widget build(BuildContext context) {

   if(isSignIn){
     return SignIn(toggleView: toggleViewFunc);
   }
   else{
     return Register(toggleView: toggleViewFunc);
   }
  }
}



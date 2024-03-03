import 'package:dubts/pages/intro/bus_home_page.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              // Color(0xFFB91736),
              // Color(0xFF281537),
              Color(0xFFFFE6E6), 
              Color(0xFFFFFFFF),// Light red
            ]
          )
        ),
        child: Column(children: [
          Padding(padding: const EdgeInsets.only(top: 150.0),
          child: Image(image: AssetImage('/assets/images/logo.jpg'),
          ),),
          SizedBox(height: 100),
          Text('Bus Koi', 
          style: TextStyle(
            fontSize: 30, 
            fontWeight: FontWeight.bold,
            color: Colors.black),
          ),
          SizedBox(height: 30), 
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BusHomePage(),
                ),
              );
            },
            child: Container(
              height: 53,
              width: 320,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black,
                  width: 2
                ),
              ),
              child: Center(
                child: Text('Get Started', 
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black
                ),
                ),
              ),
            ),
          ),
         
          SizedBox(height: 30),
          Container(
            height: 53,
            width: 320,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.black,
                width: 2
              ),
              // color: Colors.black
            ),
            child: Center(
              child: Text('Sign In', 
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black
              ),
              ),
            ),
          ),
          Spacer(),
         
        ],),
      )
    );
  }
}


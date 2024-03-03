// import 'package:bus_koi/pages/bus_home_page.dart';
import 'package:dubts/pages/intro/welcome.dart';
import 'package:dubts/pages/intro/bus_home_page.dart';
import 'package:dubts/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';


class AnimationPage extends StatefulWidget {
  const AnimationPage({Key? key});

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  bool isGetStartedClicked = true;
  final AuthService _auth = AuthService();
  bool isAnonSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => isGetStartedClicked ? BusHomePage() : WelcomePage(),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFFFFF),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Lottie.asset(
                          'assets/animations/intro1.json',
                          height: 300,
                          reverse: true,
                          repeat: true,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 15),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'BUS ',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      GoogleFonts.robotoMono().fontFamily,
                                ),
                              ),
                              TextSpan(
                                text: 'KOI?',
                                style: TextStyle(
                                  color: isGetStartedClicked ? Colors.red : Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      GoogleFonts.robotoMono().fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildButton(
                          context,
                          text: 'Get Started ',
                          onPressed: () {
                            setState(() {
                              isGetStartedClicked = true;
                              
                            });
                             
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusHomePage(),
                              ),
                            );
                          
                          },
                          isSelected: isGetStartedClicked,
                        ),
                        SizedBox(height: 20), // Add spacing between buttons
                        _buildButton(
                          context,
                          text: 'Be a guide',
                          onPressed: () {
                            setState(() {
                              isGetStartedClicked = false;
                            });
                             Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusHomePage(),
                              ),
                            );
                          },
                          isSelected: !isGetStartedClicked,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildButton(BuildContext context, {required String text, required VoidCallback onPressed, required bool isSelected}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
            return isSelected ? Colors.redAccent : Colors.white;
          } else {
            return isSelected ? Colors.red : Colors.white;
          }
        }),
        foregroundColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
          return isSelected ? Colors.white : Colors.black;
        }),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(320, 53)),
        elevation: MaterialStateProperty.all<double>(5),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 15,
        ),
      ),
    ),
  );
}
}
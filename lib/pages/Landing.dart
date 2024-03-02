import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dubts/screens/wrapper.dart';

class AnimationPage extends StatefulWidget {
  const AnimationPage({super.key});

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage> {
  bool isGetStartedClicked = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => isGetStartedClicked ? Wrapper() : Wrapper(),
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
                                      GoogleFonts.dancingScript().fontFamily,
                                ),
                              ),
                              TextSpan(
                                text: 'KOI?',
                                style: TextStyle(
                                  color: isGetStartedClicked
                                      ? Colors.red
                                      : Colors.black,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  fontFamily:
                                      GoogleFonts.dancingScript().fontFamily,
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
                                builder: (context) => Wrapper(),
                              ),
                            );
                          },
                          isSelected: isGetStartedClicked,
                        ),
                        SizedBox(height: 20), // Add spacing between buttons
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

  Widget _buildButton(BuildContext context,
      {required String text,
      required VoidCallback onPressed,
      required bool isSelected}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.hovered)) {
              return isSelected ? Colors.redAccent : Colors.white;
            } else {
              return isSelected ? Colors.red : Colors.white;
            }
          }),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
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

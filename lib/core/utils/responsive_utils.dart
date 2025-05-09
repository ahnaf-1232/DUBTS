import 'package:flutter/material.dart';

class ResponsiveUtils {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  
  static double getProportionateScreenWidth(BuildContext context, double inputWidth) {
    double screenWidth = MediaQuery.of(context).size.width;
    // 375 is the layout width that designer use
    return (inputWidth / 375.0) * screenWidth;
  }
  
  static double getProportionateScreenHeight(BuildContext context, double inputHeight) {
    double screenHeight = MediaQuery.of(context).size.height;
    // 812 is the layout height that designer use
    return (inputHeight / 812.0) * screenHeight;
  }
  
  static bool isMobile(BuildContext context) => screenWidth(context) < 600;
  static bool isTablet(BuildContext context) => screenWidth(context) >= 600 && screenWidth(context) < 900;
  static bool isDesktop(BuildContext context) => screenWidth(context) >= 900;
  
  static EdgeInsets safeAreaPadding(BuildContext context) => MediaQuery.of(context).padding;
  
  static double statusBarHeight(BuildContext context) => MediaQuery.of(context).padding.top;
  static double bottomBarHeight(BuildContext context) => MediaQuery.of(context).padding.bottom;
}
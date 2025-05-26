import 'package:dubts/core/routes/app_router.dart';
import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:dubts/core/widgets/app_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.getProportionateScreenWidth(context, 24)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Center(
                child: Container(
                  width: screenWidth * 0.3,
                  height: screenWidth * 0.3,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE53935),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.directions_bus_rounded,
                    color: Colors.white,
                    size: screenWidth * 0.15,
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Text(
                'Bus Koi?',
                style: TextStyle(
                  fontSize: screenWidth * 0.07,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Get Started',
                icon: Icons.arrow_forward,
                onPressed: () => context.go(AppRoutes.signup),
                type: ButtonType.primary,
                size: ButtonSize.large,
              ),
              SizedBox(height: screenHeight * 0.02),
              AppButton(
                text: 'Be a guide',
                icon: Icons.arrow_forward,
                onPressed: () => context.go(AppRoutes.becomeGuide),
                type: ButtonType.outline,
                size: ButtonSize.large,
              ),
              SizedBox(height: screenHeight * 0.02),
              AppButton(
                text: 'Continue as Guest',
                icon: Icons.person_outline,
                onPressed: () {
                  // TODO: Implement anonymous login logic
                  context.go(AppRoutes.home);
                },
                type: ButtonType.outline,
                size: ButtonSize.large,
              ),
              SizedBox(height: screenHeight * 0.02),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
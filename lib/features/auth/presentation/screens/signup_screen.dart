import 'package:dubts/core/routes/app_router.dart';
import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:dubts/core/widgets/app_button.dart';
import 'package:dubts/features/auth/presentation/widgets/auth_devider.dart';
import 'package:dubts/features/auth/presentation/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
              Icon(
                Icons.directions_bus_rounded,
                color: const Color(0xFFE53935),
                size: screenWidth * 0.15,
              ),
              SizedBox(height: screenHeight * 0.02),
              Text(
                'Create your account',
                style: TextStyle(
                  fontSize: screenWidth * 0.04,
                  color: Colors.black54,
                ),
              ),
              const Spacer(),
              AppButton(
                text: 'Continue with Email',
                icon: Icons.email_outlined,
                onPressed: () => context.go(AppRoutes.verifyEmail),
                type: ButtonType.secondary,
                size: ButtonSize.large,
              ),
              SizedBox(height: screenHeight * 0.03),
              const AuthDivider(),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    icon: Icons.g_mobiledata,
                    color: Colors.red,
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
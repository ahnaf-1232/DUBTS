import 'package:dubts/core/providers/auth_provider.dart';
import 'package:dubts/core/routes/app_router.dart';
import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:dubts/core/widgets/app_button.dart';
import 'package:dubts/features/auth/presentation/screens/verification_code_input_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _verifyEmail() async {
    if (_codeController.text.length != 6) {
      setState(() {
        _errorMessage = 'Please enter a valid verification code';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.verifyEmail(_codeController.text.trim());

    if (success) {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = authProvider.errorMessage ?? 'Wrong verify code';
      });
    }
  }

  Future<void> _resendCode() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.sendVerificationCode('user@example.com');

    setState(() {
      _isLoading = false;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _errorMessage = authProvider.errorMessage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveUtils.getProportionateScreenWidth(context, 24)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => context.pop(),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              SizedBox(height: screenHeight * 0.03),
              Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.directions_bus_rounded,
                      color: const Color(0xFFE53935),
                      size: screenWidth * 0.15,
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Text(
                      'Verify your email',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                      child: Text(
                        'Please enter the verification code we sent to your email address to complete the verification process.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.04),
              VerificationCodeInput(
                controller: _codeController,
                onCompleted: (value) {
                  _verifyEmail();
                },
              ),
              if (_errorMessage != null)
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.02),
                  child: Row(
                    children: [
                      const Icon(Icons.error_outline, color: Colors.red, size: 16),
                      SizedBox(width: screenWidth * 0.01),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: screenHeight * 0.04),
              AppButton(
                text: 'Verify',
                icon: Icons.check_circle_outline,
                onPressed: _isLoading ? null : _verifyEmail,
                isLoading: _isLoading,
              ),
              SizedBox(height: screenHeight * 0.02),
              Center(
                child: TextButton.icon(
                  onPressed: _isLoading ? null : _resendCode,
                  icon: const Icon(Icons.email_outlined, size: 18),
                  label: const Text('Resend the code'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFE53935),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
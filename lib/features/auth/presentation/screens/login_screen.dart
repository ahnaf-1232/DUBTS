import 'package:dubts/core/providers/auth_provider.dart';
import 'package:dubts/core/routes/app_router.dart';
import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:dubts/core/widgets/app_button.dart';
import 'package:dubts/core/widgets/app_text_fiels.dart';
import 'package:dubts/features/auth/presentation/widgets/auth_devider.dart';
import 'package:dubts/features/auth/presentation/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signIn(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success) {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = authProvider.errorMessage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = ResponsiveUtils.screenWidth(context);
    final screenHeight = ResponsiveUtils.screenHeight(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveUtils.getProportionateScreenWidth(context, 24)),
            child: Form(
              key: _formKey,
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
                        Text(
                          'Hello Again!',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'Log into your account',
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.04),
                  AppTextField(
                    controller: _emailController,
                    hint: 'Enter your email address',
                    prefixIcon: const Icon(Icons.email_outlined),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  AppTextField(
                    controller: _passwordController,
                    hint: 'Enter your password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    obscureText: true,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.02),
                  AppButton(
                    text: 'Continue',
                    onPressed: _isLoading ? null : _login,
                    isLoading: _isLoading,
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
                      SizedBox(width: screenWidth * 0.04),
                      SocialButton(
                        icon: Icons.facebook,
                        color: Colors.blue,
                        onPressed: () {},
                      ),
                      SizedBox(width: screenWidth * 0.04),
                      SocialButton(
                        icon: Icons.apple,
                        color: Colors.black,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
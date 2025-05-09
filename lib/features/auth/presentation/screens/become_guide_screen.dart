import 'package:dubts/core/providers/auth_provider.dart';
import 'package:dubts/core/routes/app_router.dart';
import 'package:dubts/core/utils/responsive_utils.dart';
import 'package:dubts/core/widgets/app_button.dart';
import 'package:dubts/core/widgets/app_text_fiels.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BecomeGuideScreen extends StatefulWidget {
  const BecomeGuideScreen({super.key});

  @override
  State<BecomeGuideScreen> createState() => _BecomeGuideScreenState();
}

class _BecomeGuideScreenState extends State<BecomeGuideScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _agreedToTerms = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      setState(() {
        _errorMessage = 'You must agree to the terms and conditions';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.signUp(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text.trim(),
      isGuide: true,
    );

    if (success) {
      if (mounted) {
        context.go(AppRoutes.verifyEmail);
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
                        Icon(
                          Icons.directions_bus_rounded,
                          color: const Color(0xFFE53935),
                          size: screenWidth * 0.15,
                        ),
                        SizedBox(height: screenHeight * 0.02),
                        Text(
                          'Become a Guide',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          'Create your account',
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
                    controller: _nameController,
                    hint: 'Enter your user name',
                    prefixIcon: const Icon(Icons.person_outline),
                    suffixIcon: const Icon(Icons.check, color: Colors.green),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: screenHeight * 0.02),
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
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: _agreedToTerms,
                          onChanged: (value) {
                            setState(() {
                              _agreedToTerms = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFFE53935),
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.02),
                      Expanded(
                        child: Row(
                          children: [
                            const Text(
                              'I agree with ',
                              style: TextStyle(fontSize: 14),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Show terms and conditions
                              },
                              child: const Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.02),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.04),
                  AppButton(
                    text: 'Continue',
                    icon: Icons.arrow_forward,
                    onPressed: _isLoading ? null : _signUp,
                    isLoading: _isLoading,
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
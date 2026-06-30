import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/auth/providers/auth_provider.dart';
import 'package:libratrack_application/features/auth/screens/otp_screen.dart';
import 'package:libratrack_application/features/auth/widgets/field_label.dart';
import 'package:libratrack_application/features/auth/widgets/input_field.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleForgotPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.forgotPassword(email);

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => OTPScreen(email: email)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Email not found')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    color: AppColors.navy,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'LibraTrack',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 28),

                // ── Card ──
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Forgot Password',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.navy,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Enter your registered university email address to receive password reset instructions.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Email
                        const FieldLabel(label: 'University Email'),
                        const SizedBox(height: 8),
                        InputField(
                          controller: _emailController,
                          hint: 'student@university.edu',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!value.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Send Reset Link Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _handleForgotPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.navy,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Send Reset Link',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.send_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Back to Login
                        Center(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.arrow_back_rounded,
                                  size: 15,
                                  color: AppColors.navy,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'Back to Login',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: AppColors.navy,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Footer
                        Center(
                          child: Text(
                            '© 2024 LibraTrack Academic Systems',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Colors.grey[500],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

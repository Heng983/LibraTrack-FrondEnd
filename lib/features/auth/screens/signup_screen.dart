import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/auth/providers/auth_provider.dart';
import 'package:libratrack_application/features/auth/screens/student_loginscreen.dart';
import 'package:libratrack_application/features/auth/widgets/department_dropdown.dart';
import 'package:libratrack_application/features/auth/widgets/field_label.dart';
import 'package:libratrack_application/features/auth/widgets/input_field.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullnameController = TextEditingController();
  final _studentIdController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _selectedDepartment = 'Library Science';

  @override
  void dispose() {
    _fullnameController.dispose();
    _studentIdController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final success = await auth.register(
      name: _fullnameController.text.trim(),
      studentId: _studentIdController.text.trim(),
      email: _emailController.text.trim(),
      department: _selectedDepartment,
      password: _passwordController.text.trim(),
    );

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const StudentLoginScreen()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.errorMessage ?? 'Registration failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              children: [
                // ── Header ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.navy,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'LibraTrack',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                        letterSpacing: 0.4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Create Student Account',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Join your university library ecosystem and\nmanage your academic resources seamlessly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600], height: 1.5),
                ),
                const SizedBox(height: 28),

                // ── Form Card ──
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        const FieldLabel(label: 'Full Name'),
                        const SizedBox(height: 8),
                        InputField(
                          controller: _fullnameController,
                          hint: 'Enter your full name',
                          icon: Icons.person_outline_rounded,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Full name is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // Student ID
                        const FieldLabel(label: 'Student ID'),
                        const SizedBox(height: 8),
                        InputField(
                          controller: _studentIdController,
                          hint: 'B20235844',
                          icon: Icons.school_outlined,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Student ID is required';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),

                        // University Email
                        const FieldLabel(label: 'University Email'),
                        const SizedBox(height: 8),
                        InputField(
                          controller: _emailController,
                          hint: 'Enter your university email',
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
                        DepartmentDropdown(
                          value: _selectedDepartment,
                          onChanged: (val) =>
                              setState(() => _selectedDepartment = val!),
                        ),
                        const SizedBox(height: 20),

                        // Password
                        const FieldLabel(label: 'Password'),
                        const SizedBox(height: 8),
                        InputField(
                          controller: _passwordController,
                          hint: 'Enter your password',
                          icon: Icons.lock_outline_rounded,
                          obscure: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Password must be at least 8 characters long',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Colors.grey[500],
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Confirm Password
                        const FieldLabel(label: 'Confirm Password'),
                        const SizedBox(height: 8),
                        InputField(
                          controller: _confirmPasswordController,
                          hint: 'Confirm your password',
                          icon: Icons.lock_outline_rounded,
                          obscure: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        // Register Button
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _handleSignUp,
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
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Sign In link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Colors.grey[700],
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: AppColors.teal,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Terms
                        Text(
                          'By signing up, you agree to our Terms of Services and Privacy Policy',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.5,
                            color: Colors.grey[700],
                            height: 1.4,
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

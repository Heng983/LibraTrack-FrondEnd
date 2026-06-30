import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/auth/providers/auth_provider.dart';
import 'package:libratrack_application/features/auth/widgets/field_label.dart';
import 'package:libratrack_application/features/auth/widgets/input_field.dart';
import 'package:libratrack_application/features/profile/widgets/profile_avatar.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  String _selectedDepartment = 'Library Science';

  final List<String> _departments = [
    'Library Science',
    'Computer Science',
    'Architecture',
    'Engineering',
    'Business',
    'Medicine',
    'Law',
    'Education',
  ];

  @override
  void initState() {
    super.initState();
    final student = context.read<AuthProvider>().student;
    _nameController.text = student?.name ?? '';
    _selectedDepartment = student?.department ?? 'Library Science';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.updateProfile(
      name: _nameController.text.trim(),
      department: _selectedDepartment,
      password: _passwordController.text.trim().isEmpty
          ? null
          : _passwordController.text.trim(),
      passwordConfirmation: _confirmPassController.text.trim().isEmpty
          ? null
          : _confirmPassController.text.trim(),
    );

    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!')),
      );
      Navigator.pop(context);
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(auth.errorMessage ?? 'Failed to update profile'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final student = auth.student;

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.navy,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: const Color(0xFFDDE3F0),
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          ProfileAvatar(
                            imageUrl: student?.profileImage,
                            name: student?.name ?? '',
                            studentId: student?.studentId ?? '',
                            onTap: () async {
                              final success = await context
                                  .read<AuthProvider>()
                                  .uploadProfileImage();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Profile image updated!'),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FieldLabel(label: 'FULL NAME'),
                            const SizedBox(height: 8),
                            InputField(
                              controller: _nameController,
                              hint: 'Enter your full name',
                              icon: Icons.person_outline_rounded,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            const FieldLabel(label: 'EMAIL ADDRESS'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAEDF5),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFD0D5E8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email_outlined,
                                    color: Color(0xFF9AA3B8),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    student?.email ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            const FieldLabel(label: 'DEPARTMENT'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: const Color(0xFFD0D5E8),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.school_outlined,
                                    color: Color(0xFF9AA3B8),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedDepartment,
                                        isExpanded: true,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.navy,
                                        ),
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: AppColors.navy,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        onChanged: (val) => setState(
                                          () => _selectedDepartment = val!,
                                        ),
                                        items: _departments.map((d) {
                                          return DropdownMenuItem(
                                            value: d,
                                            child: Text(d),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Password
                            const FieldLabel(label: 'PASSWORD'),
                            const SizedBox(height: 8),
                            InputField(
                              controller: _passwordController,
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              obscure: true,
                              validator: (value) {
                                if (value != null &&
                                    value.isNotEmpty &&
                                    value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Confirm Password
                            const FieldLabel(label: 'CONFIRM PASSWORD'),
                            const SizedBox(height: 8),
                            InputField(
                              controller: _confirmPassController,
                              hint: '••••••••',
                              icon: Icons.lock_outline_rounded,
                              obscure: true,
                              validator: (value) {
                                if (_passwordController.text.isNotEmpty &&
                                    value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            ElevatedButton(
                              onPressed: auth.isLoading ? null : _handleSave,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.navy,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: auth.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Save Changes',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
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
          ],
        ),
      ),
    );
  }
}

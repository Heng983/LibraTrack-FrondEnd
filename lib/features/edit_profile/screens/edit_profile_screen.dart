import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/auth/providers/auth_notifier.dart';
import 'package:libratrack_application/features/auth/widgets/field_label.dart';
import 'package:libratrack_application/features/auth/widgets/input_field.dart';
import 'package:libratrack_application/features/profile/widgets/profile_avatar.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
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
    final student = ref.read(authProvider).student;
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

    final auth = ref.read(authProvider.notifier);
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
      GlassSnackBar.show(
        context,
        'Profile updated successfully!',
        type: GlassSnackBarType.success,
      );
      Navigator.pop(context);
    } else if (context.mounted) {
      final errorMessage = ref.read(authProvider).errorMessage;
      GlassSnackBar.show(
        context,
        errorMessage ?? 'Failed to update profile',
        type: GlassSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
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
                    child: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.navy,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
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
            Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: AppColors.borderColor,
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      child: Column(
                        children: [
                          ProfileAvatar(
                            imageUrl: student?.profileImage,
                            name: student?.name ?? '',
                            studentId: student?.studentId ?? '',
                            onTap: () async {
                              final success = await ref
                                  .read(authProvider.notifier)
                                  .uploadProfileImage();
                              if (success && context.mounted) {
                                GlassSnackBar.show(
                                  context,
                                  'Profile image updated!',
                                  type: GlassSnackBarType.success,
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
                                color: AppColors.fieldBg,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.email_outlined,
                                    color: AppColors.hintGray,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    student?.email ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textMuted,
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
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    color: AppColors.hintGray,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedDepartment,
                                        isExpanded: true,
                                        icon: Icon(
                                          Icons.keyboard_arrow_down_rounded,
                                          color: AppColors.navy,
                                        ),
                                        style: TextStyle(
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
                                foregroundColor: AppColors.onPrimary,
                                minimumSize: const Size.fromHeight(52),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: auth.isLoading
                                  ? CircularProgressIndicator(
                                      color: AppColors.onPrimary,
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

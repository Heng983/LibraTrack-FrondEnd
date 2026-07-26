import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/theme/theme_notifier.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/auth/providers/auth_notifier.dart';
import 'package:libratrack_application/features/auth/screens/student_loginscreen.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_notifier.dart';
import 'package:libratrack_application/features/profile/widgets/edit_profile_button.dart';
import 'package:libratrack_application/features/profile/widgets/logout_button.dart';
import 'package:libratrack_application/features/profile/widgets/profile_avatar.dart';
import 'package:libratrack_application/features/profile/widgets/profile_info_card.dart';
import 'package:libratrack_application/features/profile/widgets/profile_stats.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).loadCurrentUser();
      ref.read(borrowCartProvider.notifier).fetchMyBorrows();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final borrow = ref.watch(borrowCartProvider);
    final student = auth.student;

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.menu_rounded, color: AppColors.navy, size: 24),
                  const SizedBox(width: 12),
                  Text(
                    'LibraTrack',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    const SizedBox(height: 28),
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
                    const SizedBox(height: 20),
                    EditProfileButton(onTap: () {}),
                    const SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ProfileStats(
                        active: borrow.active.length,
                        overdue: 0,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ProfileInfoCard(
                        items: [
                          ProfileInfoItem(
                            icon: Icons.email_rounded,
                            label: 'EMAIL ADDRESS',
                            value: student?.email ?? '',
                          ),
                          ProfileInfoItem(
                            icon: Icons.account_balance_outlined,
                            label: 'DEPARTMENT',
                            value: student?.department ?? 'N/A',
                          ),
                          ProfileInfoItem(
                            icon: Icons.badge_outlined,
                            label: 'STUDENT ID',
                            value: student?.studentId ?? '',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: AppColors.fieldBg,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.dark_mode_rounded,
                                color: AppColors.navy,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Text(
                                'Dark Mode',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            Switch(
                              value: ref.watch(themeProvider),
                              activeThumbColor: AppColors.teal,
                              onChanged: (_) => ref
                                  .read(themeProvider.notifier)
                                  .toggle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: LogoutButton(
                        onTap: () async {
                          await ref.read(authProvider.notifier).logout();
                          if (context.mounted) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StudentLoginScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        },
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

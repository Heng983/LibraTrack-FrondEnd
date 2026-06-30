import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/auth/providers/auth_provider.dart';
import 'package:libratrack_application/features/auth/screens/student_loginscreen.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:libratrack_application/features/profile/widgets/edit_profile_button.dart';
import 'package:libratrack_application/features/profile/widgets/logout_button.dart';
import 'package:libratrack_application/features/profile/widgets/profile_avatar.dart';
import 'package:libratrack_application/features/profile/widgets/profile_info_card.dart';
import 'package:libratrack_application/features/profile/widgets/profile_stats.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().loadCurrentUser();
      context.read<BorrowCartProvider>().fetchMyBorrows();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final borrow = context.watch<BorrowCartProvider>();
    final student = auth.student;

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: const [
                  Icon(Icons.menu_rounded, color: AppColors.navy, size: 24),
                  SizedBox(width: 12),
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
            const Divider(height: 1, color: Colors.grey),
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
                      child: LogoutButton(
                        onTap: () async {
                          await context.read<AuthProvider>().logout();
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

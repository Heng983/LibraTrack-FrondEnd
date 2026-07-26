import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/theme/theme_notifier.dart';
import 'package:libratrack_application/features/admin/providers/dashboard_notifier.dart';
import 'package:libratrack_application/features/admin/widgets/admin_account_details.dart';
import 'package:libratrack_application/features/admin/widgets/admin_profile_header.dart';
import 'package:libratrack_application/features/admin/widgets/admin_stats_card.dart';
import 'package:libratrack_application/features/auth/providers/auth_notifier.dart';
import 'package:libratrack_application/features/auth/screens/student_loginscreen.dart';

class AdminProfileScreen extends ConsumerStatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  ConsumerState<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends ConsumerState<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final state = ref.read(dashboardProvider);
      if (state.dashboard == null) {
        ref.read(dashboardProvider.notifier).loadDashboard();
      }
    });
  }

  String _formatDate(DateTime dt) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final admin = ref.watch(authProvider).admin;
    final dash = ref.watch(dashboardProvider).dashboard;
    final isDark = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Text(
                    'Profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await ref.read(authProvider.notifier).logout();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const StudentLoginScreen(),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: Icon(Icons.logout, color: AppColors.red, size: 24),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AdminProfileHeader(
                      name: admin?.name ?? 'Admin',
                      role: 'Head Librarian / System Admin',
                      onEditTap: () {},
                    ),
                    const SizedBox(height: 16),
                    AdminStatsCard(
                      totalBooks: dash?.totalBooks ?? 0,
                      totalUsers: dash?.totalStudents ?? 0,
                      totalRequests: dash?.pendingRequests ?? 0,
                    ),
                    const SizedBox(height: 16),
                    AdminAccountDetails(
                      email: admin?.adminId ?? '—',
                      staffId: admin?.adminId ?? 'LT-ADM-0001',
                      access: 'Super Admin',
                      lastLogin: admin?.lastLoginAt != null
                          ? _formatDate(admin!.lastLoginAt!)
                          : 'First login',
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.dark_mode_outlined,
                            color: AppColors.teal,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Dark Mode',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Switch(
                            value: isDark,
                            activeThumbColor: AppColors.teal,
                            onChanged: (_) =>
                                ref.read(themeProvider.notifier).toggle(),
                          ),
                        ],
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

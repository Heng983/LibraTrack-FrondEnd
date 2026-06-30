import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/admin/providers/dashboard_provider.dart';
import 'package:libratrack_application/features/admin/widgets/admin_account_details.dart';
import 'package:libratrack_application/features/admin/widgets/admin_profile_header.dart';
import 'package:libratrack_application/features/admin/widgets/admin_stats_card.dart';
import 'package:libratrack_application/features/auth/providers/auth_provider.dart';
import 'package:libratrack_application/features/auth/screens/student_loginscreen.dart';
import 'package:provider/provider.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final dash = context.read<DashboardProvider>();
      if (dash.dashboard == null) {
        dash.loadDashboard();
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
    final admin = context.watch<AuthProvider>().admin;
    final dash = context.watch<DashboardProvider>().dashboard;
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
                      await context.read<AuthProvider>().logout();
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
                    child: const Icon(
                      Icons.logout,
                      color: AppColors.red,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
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

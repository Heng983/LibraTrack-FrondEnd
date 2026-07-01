import 'dart:async';
import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/admin/providers/dashboard_provider.dart';
import 'package:libratrack_application/features/admin/widgets/dashboard_stat_card.dart';
import 'package:libratrack_application/features/admin/widgets/recent_activity.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadDashboard();
    });

    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) context.read<DashboardProvider>().loadDashboard();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    await context.read<DashboardProvider>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: AppColors.bgcolor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_rounded,
                    color: Color(0xFF1A1A2E),
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.notifications_outlined,
                    color: Colors.grey[600],
                    size: 24,
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Colors.grey),
            Expanded(
              child: Consumer<DashboardProvider>(
                builder: (context, provider, _) {
                  if (provider.isLoading && provider.dashboard == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (provider.error != null && provider.dashboard == null) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(child: Text(provider.error!)),
                          ),
                        ],
                      ),
                    );
                  }
                  final d = provider.dashboard;
                  if (d == null) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(physics: AlwaysScrollableScrollPhysics()),
                    );
                  }
                  final availabilityPercent = d.totalBooks > 0
                      ? ((d.availableBooks / d.totalBooks) * 100).round()
                      : 0;
                  return RefreshIndicator(
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          DashboardStatCard(
                            icon: Icons.menu_book_rounded,
                            iconBgColor: const Color(0xFFEEF0FF),
                            iconColor: const Color(0xFF5B5FC7),
                            leftBorderColor: const Color(0xFF5B5FC7),
                            label: 'TOTAL BOOKS',
                            value: '${d.totalBooks}',
                            badgeText: 'Students: ${d.totalStudents}',
                            badgeColor: AppColors.green,
                          ),
                          const SizedBox(height: 12),
                          DashboardStatCard(
                            icon: Icons.check_circle_outline_rounded,
                            iconBgColor: const Color(0xFFE8F8F0),
                            iconColor: AppColors.green,
                            leftBorderColor: AppColors.green,
                            label: 'AVAILABLE BOOKS',
                            value: '${d.availableBooks}',
                            badgeText: '$availabilityPercent%',
                            badgeColor: AppColors.green,
                          ),
                          const SizedBox(height: 12),
                          DashboardStatCard(
                            icon: Icons.library_books_rounded,
                            iconBgColor: const Color(0xFFEEF4FF),
                            iconColor: Colors.blue,
                            leftBorderColor: Colors.blue,
                            label: 'ACTIVE BORROWS',
                            value: '${d.activeBorrows}',
                            badgeText: 'Overdue: ${d.overdueCount}',
                            badgeColor: AppColors.red,
                          ),
                          const SizedBox(height: 12),
                          DashboardStatCard(
                            icon: Icons.pending_outlined,
                            iconBgColor: const Color(0xFFFFF0F0),
                            iconColor: Colors.red,
                            leftBorderColor: Colors.red,
                            label: 'PENDING REQUESTS',
                            value: '${d.pendingRequests}',
                            badgeText: 'Pending',
                            badgeColor: Colors.red,
                          ),
                          const SizedBox(height: 24),
                          RecentActivity(activities: provider.activities),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

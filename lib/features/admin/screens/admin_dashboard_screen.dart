import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/admin/providers/dashboard_notifier.dart';
import 'package:libratrack_application/features/admin/widgets/dashboard_stat_card.dart';
import 'package:libratrack_application/features/admin/widgets/notification_bell.dart';
import 'package:libratrack_application/features/admin/widgets/recent_activity.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(dashboardProvider.notifier).loadDashboard();
    });

    _timer = Timer.periodic(const Duration(seconds: 15), (_) {
      if (mounted) ref.read(dashboardProvider.notifier).loadDashboard();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(dashboardProvider.notifier).loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(dashboardProvider);

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
                  Icon(
                    Icons.menu_rounded,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Dashboard",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  const NotificationBell(),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.divider),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (state.isLoading && state.dashboard == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.error != null && state.dashboard == null) {
                    return RefreshIndicator(
                      onRefresh: _refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
                            child: Center(child: Text(state.error!)),
                          ),
                        ],
                      ),
                    );
                  }
                  final d = state.dashboard;
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
                            iconBgColor: const Color(
                              0xFF5B5FC7,
                            ).withValues(alpha: 0.15),
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
                            iconBgColor: AppColors.green.withValues(
                              alpha: 0.15,
                            ),
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
                            iconBgColor: Colors.blue.withValues(alpha: 0.15),
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
                            iconBgColor: AppColors.red.withValues(alpha: 0.15),
                            iconColor: AppColors.red,
                            leftBorderColor: AppColors.red,
                            label: 'PENDING REQUESTS',
                            value: '${d.pendingRequests}',
                            badgeText: 'Pending',
                            badgeColor: AppColors.red,
                          ),
                          const SizedBox(height: 24),
                          RecentActivity(activities: state.activities),
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

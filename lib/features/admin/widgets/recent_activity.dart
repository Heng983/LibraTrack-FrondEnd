import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/admin/models/dashboard_model.dart';
import 'package:libratrack_application/features/admin/providers/borrow_request_notifier.dart';
import 'package:libratrack_application/features/admin/providers/dashboard_notifier.dart';

class RecentActivity extends ConsumerWidget {
  final List<ActivityModel> activities;

  const RecentActivity({super.key, required this.activities});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'VIEW ALL',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5B5FC7),
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (activities.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Center(
                child: Text(
                  'No recent activity',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (_, index) {
                final item = activities[index];
                final isLast = index == activities.length - 1;

                return Column(
                  children: [
                    _ActivityRow(
                      activity: item,
                      onApprove: item.type == ActivityType.request
                          ? () async {
                              final ok = await ref
                                  .read(borrowRequestProvider.notifier)
                                  .approve(item.id);
                              if (ok && context.mounted) {
                                ref
                                    .read(dashboardProvider.notifier)
                                    .loadDashboard();
                                GlassSnackBar.show(
                                  context,
                                  'Request approved!',
                                  type: GlassSnackBarType.success,
                                );
                              }
                            }
                          : null,
                      onReject: item.type == ActivityType.request
                          ? () async {
                              final ok = await ref
                                  .read(borrowRequestProvider.notifier)
                                  .reject(item.id);
                              if (ok && context.mounted) {
                                ref
                                    .read(dashboardProvider.notifier)
                                    .loadDashboard();
                                GlassSnackBar.show(
                                  context,
                                  'Request rejected.',
                                  type: GlassSnackBarType.info,
                                );
                              }
                            }
                          : null,
                    ),
                    if (!isLast) Divider(height: 1, color: AppColors.divider),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const _ActivityRow({required this.activity, this.onApprove, this.onReject});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: _iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: _iconColor, size: 17),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.message,
                  style: TextStyle(
                    fontSize: 12.5,
                    color: AppColors.textPrimary,
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  activity.timeAgo,
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildAction(),
        ],
      ),
    );
  }

  Widget _buildAction() {
    switch (activity.type) {
      case ActivityType.request:
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: onApprove,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_rounded,
                  color: AppColors.green,
                  size: 16,
                ),
              ),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: onReject,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.red.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  color: AppColors.red,
                  size: 16,
                ),
              ),
            ),
          ],
        );
      case ActivityType.returned:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.green.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'SUCCESS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.green,
              letterSpacing: 0.5,
            ),
          ),
        );
      case ActivityType.system:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.textMuted.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'SYSTEM',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
              letterSpacing: 0.5,
            ),
          ),
        );
    }
  }

  Color get _iconBgColor {
    switch (activity.type) {
      case ActivityType.request:
        return const Color(0xFF5B5FC7).withValues(alpha: 0.15);
      case ActivityType.returned:
        return AppColors.green.withValues(alpha: 0.15);
      case ActivityType.system:
        return AppColors.textMuted.withValues(alpha: 0.15);
    }
  }

  Color get _iconColor {
    switch (activity.type) {
      case ActivityType.request:
        return const Color(0xFF5B5FC7);
      case ActivityType.returned:
        return AppColors.green;
      case ActivityType.system:
        return AppColors.textMuted;
    }
  }

  IconData get _icon {
    switch (activity.type) {
      case ActivityType.request:
        return Icons.person_add_outlined;
      case ActivityType.returned:
        return Icons.keyboard_return_rounded;
      case ActivityType.system:
        return Icons.tune_rounded;
    }
  }
}

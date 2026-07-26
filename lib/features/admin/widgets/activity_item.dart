import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/admin/models/dashboard_model.dart';

class ActivityItem extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback? onApprove;
  final VoidCallback? onReject;

  const ActivityItem({
    super.key,
    required this.activity,
    this.onApprove,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(_icon, color: _iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.message,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.timeAgo,
                  style: TextStyle(fontSize: 11, color: AppColors.textMuted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (activity.type == ActivityType.request)
            Row(
              children: [
                GestureDetector(
                  onTap: onApprove,
                  child: Icon(
                    Icons.check_rounded,
                    color: AppColors.green,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onReject,
                  child: Icon(
                    Icons.close_rounded,
                    color: AppColors.red,
                    size: 22,
                  ),
                ),
              ],
            )
          else if (activity.type == ActivityType.returned)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            )
          else if (activity.type == ActivityType.system)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
            ),
        ],
      ),
    );
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

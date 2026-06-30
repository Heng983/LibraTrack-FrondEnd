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
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF333333),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activity.timeAgo,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
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
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppColors.green,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onReject,
                  child: const Icon(
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
                color: const Color(0xFFE8F8F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
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
                color: const Color(0xFFF0F0F0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'SYSTEM',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.grey,
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
        return const Color(0xFFEEF0FF);
      case ActivityType.returned:
        return const Color(0xFFE8F8F0);
      case ActivityType.system:
        return const Color(0xFFF0F0F0);
    }
  }

  Color get _iconColor {
    switch (activity.type) {
      case ActivityType.request:
        return const Color(0xFF5B5FC7);
      case ActivityType.returned:
        return AppColors.green;
      case ActivityType.system:
        return Colors.grey;
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

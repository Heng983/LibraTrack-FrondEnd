import 'package:flutter/material.dart';
import 'package:libratrack_application/features/admin/models/dashboard_model.dart';

class RecentActivity extends StatelessWidget {
  final List<ActivityModel> activities;

  const RecentActivity({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
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
                  color: Color(0xFF1A1A2E),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Text(
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
                    onApprove: () {},
                    onReject: () {},
                  ),
                  if (!isLast)
                    const Divider(height: 1, color: Color(0xFFF0F2F8)),
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
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF2A2A3A),
                    height: 1.4,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  activity.timeAgo,
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
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
                  color: const Color(0xFFE8F8F0),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.green,
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
                  color: const Color(0xFFFFEEEE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.red,
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
            color: const Color(0xFFE8F8F0),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'SUCCESS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.green,
              letterSpacing: 0.5,
            ),
          ),
        );

      case ActivityType.system:
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        );
    }
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
        return Colors.green;
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

import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class ProfileStats extends StatelessWidget {
  final int active;
  final int overdue;

  const ProfileStats({super.key, required this.active, required this.overdue});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: "ACTIVE",
            value: active,
            valueColor: AppColors.navy,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            label: "OVERDUE",
            value: overdue,
            valueColor: AppColors.red,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color valueColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[500],
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class AdminStatsCard extends StatelessWidget {
  final int totalBooks;
  final int totalUsers;
  final int totalRequests;

  const AdminStatsCard({
    super.key,
    required this.totalBooks,
    required this.totalUsers,
    required this.totalRequests,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _StatItem(
            value: _formatNumber(totalBooks),
            label: 'BOOKS',
            color: AppColors.textPrimary,
            showDivider: true,
          ),
          _StatItem(
            value: _formatNumber(totalUsers),
            label: 'USERS',
            color: AppColors.green,
            showDivider: true,
          ),
          _StatItem(
            value: _formatNumber(totalRequests),
            label: 'REQUESTS',
            color: AppColors.red,
            showDivider: false,
          ),
        ],
      ),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000) {
      return '${(n / 1000).toStringAsFixed(n % 1000 == 0 ? 0 : 1)}K';
    }
    return n.toString();
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final bool showDivider;

  const _StatItem({
    required this.value,
    required this.label,
    required this.color,
    required this.showDivider,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(right: BorderSide(color: AppColors.borderColor))
              : null,
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

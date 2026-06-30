import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  final Color leftBorderColor;
  final String label;
  final String value;
  final String? badgeText;
  final Color? badgeColor;

  const DashboardStatCard({
    super.key,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    required this.leftBorderColor,
    required this.label,
    required this.value,
    this.badgeText,
    this.badgeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: leftBorderColor, width: 4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          if (badgeText != null)
            Text(
              badgeText!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: badgeColor ?? Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}

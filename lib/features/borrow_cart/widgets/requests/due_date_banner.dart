import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class DueDateBanner extends StatelessWidget {
  final String dueDateFormatted;

  const DueDateBanner({super.key, required this.dueDateFormatted});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFFDCE1FF), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.calendar_month_rounded, color: AppColors.navy, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Based on your selection, this book will be due on:',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.navy,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  dueDateFormatted,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'A reminder will be sent to your email 2 days before the due date.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

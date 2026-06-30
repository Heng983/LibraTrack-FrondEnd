import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class HistoryAppBar extends StatelessWidget {
  const HistoryAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Icon(Icons.menu_rounded, color: AppColors.navy, size: 24),
          SizedBox(width: 12),
          Text(
            "History",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
        ],
      ),
    );
  }
}

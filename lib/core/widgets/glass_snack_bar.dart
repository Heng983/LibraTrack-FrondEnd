import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

enum GlassSnackBarType { info, success, error }

class GlassSnackBar {
  static void show(
    BuildContext context,
    String message, {
    GlassSnackBarType type = GlassSnackBarType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    final (icon, accent) = switch (type) {
      GlassSnackBarType.success => (
        Icons.check_circle_rounded,
        const Color(0xFF2E9E6B),
      ),
      GlassSnackBarType.error => (Icons.error_rounded, AppColors.red),
      GlassSnackBarType.info => (Icons.info_rounded, AppColors.navy),
    };

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        padding: EdgeInsets.zero,
        content: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.card.withValues(alpha: 0.55),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.card.withValues(alpha: 0.7),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(icon, color: accent, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback onSubmit;
  final VoidCallback onCancel;

  const SubmitButton({
    super.key,
    required this.onSubmit,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Submit ──
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            minimumSize: const Size.fromHeight(
              52,
            ), // ← use this instead of SizedBox
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            'Submit Request',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: onCancel,
          child: Text(
            'CANCEL REQUEST',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[800],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}

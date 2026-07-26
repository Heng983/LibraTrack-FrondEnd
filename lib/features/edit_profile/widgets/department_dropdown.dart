import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class DepartmentDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const DepartmentDropdown({
    super.key,
    required this.value,
    required this.onChanged,
  });

  static const List<String> departments = [
    'Library Science',
    'Computer Science',
    'Engineering',
    'Mathematics',
    'Physics',
    'Biology',
    'Literature',
    'History',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "DEPARTMENT",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          icon: Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.hintGray,
          ),
          style: TextStyle(fontSize: 15, color: AppColors.navy),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.school_outlined,
              size: 20,
              color: AppColors.hintGray,
            ),
            filled: true,
            fillColor: AppColors.card,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.navy, width: 1.5),
            ),
          ),
          items: departments
              .map((dept) => DropdownMenuItem(value: dept, child: Text(dept)))
              .toList(),
        ),
      ],
    );
  }
}

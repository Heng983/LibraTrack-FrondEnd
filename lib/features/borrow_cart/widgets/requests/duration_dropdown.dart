import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class DurationDropdown extends StatelessWidget {
  final String selectedDuration;
  final List<String> durations;
  final ValueChanged<String?> onChanged;

  const DurationDropdown({
    super.key,
    required this.selectedDuration,
    required this.durations,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedDuration,
          isExpanded: true,
          dropdownColor: AppColors.card,
          icon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.black),
          style: TextStyle(
            fontSize: 14,
            color: AppColors.black,
            fontWeight: FontWeight.w500,
          ),
          onChanged: onChanged,
          items: durations.map((d) {
            return DropdownMenuItem(value: d, child: Text(d));
          }).toList(),
        ),
      ),
    );
  }
}

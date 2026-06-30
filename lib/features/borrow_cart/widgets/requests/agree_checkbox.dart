import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class AgreeCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const AgreeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.navy,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            "I agree to return this book by the due date and library policies.",
            style: TextStyle(fontSize: 13, color: AppColors.black, height: 1.4),
          ),
        ),
      ],
    );
  }
}

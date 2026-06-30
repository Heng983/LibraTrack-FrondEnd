import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class ProfileFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType keyboardType;
  final bool enabled;
  final bool obscureText;

  const ProfileFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF888888),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          enabled: enabled,
          obscureText: obscureText,
          style: TextStyle(
            fontSize: 15,
            color: enabled ? AppColors.navy : const Color(0xFF999999),
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 20, color: Color(0xFF999999)),
            filled: true,
            fillColor: enabled ? Colors.white : Color(0xFFF5F6FA),
            contentPadding: EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFDDDDDD)),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Color(0xFFEEEEEE)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.navy, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

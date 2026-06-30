import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class ReasonTextField extends StatelessWidget {
  final TextEditingController controller;

  const ReasonTextField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText:
            'Optional: Provide context for the librarian\n(e.g., research project)',
        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Color(0xFFDDDDDD)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDDDDD)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.5),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
          color: Color(0xFF3A3A4A),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/requests/info_row.dart';

class StudentInfoCard extends StatelessWidget {
  final String name;
  final String studentId;
  final String email;
  final String? department;

  const StudentInfoCard({
    super.key,
    required this.name,
    required this.studentId,
    required this.email,
    this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "STUDENT INFORMATION",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),
          InfoRow(label: 'Name', value: name),
          InfoRow(label: 'Student ID', value: studentId),
          InfoRow(label: 'Email', value: email),
          if (department != null)
            InfoRow(label: 'Department', value: department!),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class AdminAccountDetails extends StatelessWidget {
  final String email;
  final String staffId;
  final String access;
  final String lastLogin;

  const AdminAccountDetails({
    super.key,
    required this.email,
    required this.staffId,
    required this.access,
    required this.lastLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.teal,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailItem(label: 'EMAIL', value: email),
                    const SizedBox(height: 12),
                    _DetailItem(label: 'ACCESS', value: access, isAccess: true),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DetailItem(label: 'STAFF ID', value: staffId),
                    const SizedBox(height: 12),
                    _DetailItem(label: 'LAST LOGIN', value: lastLogin),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  final String label;
  final String value;
  final bool isAccess;

  const _DetailItem({
    required this.label,
    required this.value,
    this.isAccess = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.grey[500],
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        isAccess
            ? Row(
                children: [
                  const Icon(Icons.circle, size: 8, color: Colors.green),
                  const SizedBox(width: 6),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1A1A2E),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              )
            : Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF1A1A2E),
                  fontWeight: FontWeight.w500,
                ),
              ),
      ],
    );
  }
}

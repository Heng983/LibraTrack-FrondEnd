import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class AdminProfileHeader extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String role;
  final VoidCallback onEditTap;

  const AdminProfileHeader({
    super.key,
    this.imageUrl,
    required this.name,
    required this.role,
    required this.onEditTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 28),
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
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFEEEEEE), width: 3),
            ),
            child: ClipOval(
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: onEditTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.edit_rounded, color: AppColors.teal, size: 16),
                SizedBox(width: 6),
                Text(
                  'Edit Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEAEDF5),
      child: const Icon(Icons.person_rounded, size: 50, color: Colors.grey),
    );
  }
}

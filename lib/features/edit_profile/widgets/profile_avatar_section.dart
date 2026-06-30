import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String name;
  final String studentId;
  final VoidCallback onEditPhoto;

  const ProfileAvatarSection({
    super.key,
    required this.name,
    required this.onEditPhoto,
    required this.studentId,
  });

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Color(0xFFDDE3F5), width: 3),
            ),
            child: ClipOval(
              child: Image.network(
                'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=600',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Color(0xFFEAEDF5),
                  child: Icon(
                    Icons.person_rounded,
                    size: 48,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 2,
            right: 2,
            child: GestureDetector(
              onTap: onEditPhoto,
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.navy,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            name,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Student ID: $studentId",
            style: TextStyle(fontSize: 13, color: Color(0xFF888888)),
          ),
        ],
      ),
    );
  }
}

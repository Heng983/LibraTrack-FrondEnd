import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/edit_profile/screens/edit_profile_screen.dart';

class EditProfileButton extends StatelessWidget {
  final VoidCallback onTap;

  const EditProfileButton({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const EditProfileScreen()),
      ),
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.navy, width: 1.5),
        foregroundColor: AppColors.navy,
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      icon: Icon(Icons.edit_rounded, size: 16),
      label: Text(
        'Edit Profile',
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      ),
    );
  }
}

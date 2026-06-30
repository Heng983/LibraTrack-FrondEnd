import 'package:flutter/material.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String studentId;
  final VoidCallback? onTap;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    required this.studentId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // full URL for image
    final fullUrl = imageUrl != null
        ? '${ApiConstants.baseUrl.replaceAll('/api', '')}$imageUrl'
        : null;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.teal, width: 3),
                ),
                child: ClipOval(
                  child: fullUrl != null
                      ? Image.network(
                          fullUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
              ),

              // Camera icon overlay
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.navy,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.camera_alt_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Text(
          name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.navy,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ID: $studentId',
          style: TextStyle(fontSize: 14, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFFEAEDF5),
      child: const Icon(Icons.person_rounded, size: 50, color: Colors.grey),
    );
  }
}

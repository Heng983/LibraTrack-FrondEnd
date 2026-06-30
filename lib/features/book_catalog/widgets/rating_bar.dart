import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class RatingBar extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingBar({super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ...List.generate(5, (index) {
          return Icon(
            index < rating.floor()
                ? Icons.star_rounded
                : index < rating
                ? Icons.star_half_rounded
                : Icons.star_outline_rounded,
            color: AppColors.starcolor,
            size: 20,
          );
        }),
        const SizedBox(width: 8),
        Text(
          "$rating ($reviewCount Reviews)",
          style: TextStyle(fontSize: 13, color: Colors.black),
        ),
      ],
    );
  }
}

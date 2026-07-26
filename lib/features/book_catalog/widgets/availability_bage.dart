import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';

class AvailabilityBage extends StatelessWidget {
  const AvailabilityBage({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: book.available
                ? AppColors.teal.withValues(alpha: 0.15)
                : AppColors.red.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: book.available
                  ? AppColors.teal.withValues(alpha: 0.15)
                  : AppColors.red.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                book.available
                    ? Icons.check_circle_outline
                    : Icons.cancel_outlined,
                size: 13,
                color: book.available ? AppColors.teal : AppColors.red,
              ),
              const SizedBox(width: 4),
              Text(
                book.available
                    ? "Available - ${book.copiesLeft} copies left"
                    : "Borrowed",
                style: TextStyle(
                  fontSize: 12,
                  color: book.available ? AppColors.teal : AppColors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.fieldBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            book.category,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.navy,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

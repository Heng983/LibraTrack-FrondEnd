import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';

class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        children: [
          Image.network(
            book.cover,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Container(
              color: const Color(0xFF1A2A4A),
              child: Center(
                child: Icon(
                  Icons.book_rounded,
                  size: 80,
                  color: Colors.white54,
                ),
              ),
            ),
          ),
          Container(
            height: 320,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: AlignmentGeometry.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.2),
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),
          Positioned(
            top: 42,
            left: 25,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.card.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_back_rounded,
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
          Positioned(
            top: 42,
            right: 25,
            child: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.card.withValues(alpha: 0.9),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.share_rounded, color: AppColors.navy, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}

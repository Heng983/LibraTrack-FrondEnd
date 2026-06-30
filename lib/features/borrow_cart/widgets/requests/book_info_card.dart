import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';

class BookInfoCard extends StatelessWidget {
  final BookModel book;

  const BookInfoCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              book.cover,
              width: 100,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 125,
                color: const Color(0xFFEAEDF5),
                child: const Icon(
                  Icons.book_rounded,
                  color: Colors.grey,
                  size: 30,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.category.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.teal,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  book.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  book.author,
                  style: TextStyle(fontSize: 13, color: Colors.grey[800]),
                ),
                const SizedBox(height: 8),
                if (book.available)
                  Row(
                    children: const [
                      Icon(
                        Icons.check_circle_rounded,
                        size: 12,
                        color: Color(0xFF006A61),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Available for borrow',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF006A61),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

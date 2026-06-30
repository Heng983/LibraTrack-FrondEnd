import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';

class CartItem extends StatelessWidget {
  final BookModel book;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const CartItem({
    super.key,
    required this.book,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    book.cover,
                    width: 90,
                    height: 120,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 70,
                      height: 90,
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
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 28,
                    ), // space for delete
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.category.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.teal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          book.author,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (book.available)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F8F0),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color(0xFF86F2E4),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  size: 12,
                                  color: Color(0xFF006F66),
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Available for borrow',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF006F66),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: onRemove,
                child: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.redAccent,
                  size: 22,
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
                size: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

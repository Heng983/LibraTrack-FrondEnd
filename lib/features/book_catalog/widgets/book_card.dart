import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/book_catalog/screens/book_detail_screen.dart';

class BookCard extends StatelessWidget {
  const BookCard({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final bool available = book.available;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => BookDetailScreen(book: book)),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    book.cover,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFEAEDF5),
                      width: double.infinity,
                      child: const Icon(
                        Icons.book_rounded,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: available
                          ? const Color(0xFF86F2E4)
                          : const Color(0xFFFFDAD6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      available ? "Available" : "Borrowed",
                      style: TextStyle(
                        color: available
                            ? Color(0xFF006F66)
                            : Color(0xFF93000A),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            book.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            book.author,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
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
                ? const Color(0xFF86F2E4)
                : const Color(0xFFFFDAD6),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: book.available
                  ? const Color(0xFF86F2E4)
                  : const Color(0xFFFFDAD6),
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
                color: book.available
                    ? const Color(0xFF006F66)
                    : const Color(0xFF93000A),
              ),
              const SizedBox(width: 4),
              Text(
                book.available
                    ? "Available - ${book.copiesLeft} copies left"
                    : "Borrowed",
                style: TextStyle(
                  fontSize: 12,
                  color: book.available
                      ? const Color(0xFF006F66)
                      : const Color(0xFF93000A),
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
            color: Color(0xFFF0F2F8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            book.category,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF0D1B4B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

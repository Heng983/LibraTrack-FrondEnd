import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';

class TechnicalDetails extends StatelessWidget {
  const TechnicalDetails({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF0FB), // light lavender background
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // left-align title
        children: [
          const Text(
            "Technical Details",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D1B4B),
            ),
          ),
          const SizedBox(height: 16),
          _DetailRow(label: "ISBN", value: book.isbn),
          _DetailRow(label: "Publisher", value: book.publisher),
          _DetailRow(label: "Published", value: book.published),
          _DetailRow(label: "Language", value: book.language),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey[800])),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }
}

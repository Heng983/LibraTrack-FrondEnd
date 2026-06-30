import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/book_catalog/widgets/availability_bage.dart';
import 'package:libratrack_application/features/book_catalog/widgets/book_cover.dart';
import 'package:libratrack_application/features/book_catalog/widgets/borrow_button.dart';
import 'package:libratrack_application/features/book_catalog/widgets/rating_bar.dart';
import 'package:libratrack_application/features/book_catalog/widgets/technical_details.dart';

class BookDetailScreen extends StatelessWidget {
  const BookDetailScreen({super.key, required this.book});

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BookCover(book: book),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AvailabilityBage(book: book),
                      const SizedBox(height: 14),
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RatingBar(
                        rating: book.rating,
                        reviewCount: book.reviewCount,
                      ),
                      const SizedBox(height: 20),
                      const Divider(color: Colors.grey, thickness: 1),
                      const SizedBox(height: 16),
                      Text(
                        "Book Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        book.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TechnicalDetails(book: book),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BorrowButton(book: book),
          ),
        ],
      ),
    );
  }
}

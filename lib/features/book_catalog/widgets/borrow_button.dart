import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:provider/provider.dart';

class BorrowButton extends StatelessWidget {
  final BookModel book;

  const BorrowButton({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<BorrowCartProvider>();
    final inCart = cart.contains(book);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: ElevatedButton.icon(
        onPressed: book.available && !inCart
            ? () {
                cart.addItem(book);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Added to borrow cart!'),
                    duration: Duration(seconds: 1),
                  ),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: inCart ? Colors.green : AppColors.navy,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        icon: Icon(
          inCart ? Icons.check_rounded : Icons.library_books_rounded,
          size: 20,
        ),
        label: Text(
          !book.available
              ? 'Out of Stock'
              : inCart
              ? 'Added to Cart'
              : 'Request to Borrow',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

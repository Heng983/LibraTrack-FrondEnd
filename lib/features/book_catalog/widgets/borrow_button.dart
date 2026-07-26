import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_notifier.dart';

class BorrowButton extends ConsumerWidget {
  final BookModel book;

  const BorrowButton({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(borrowCartProvider);
    final inCart = cart.cartItems.any((b) => b.id == book.id);

    return Container(
      color: AppColors.card,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: ElevatedButton.icon(
        onPressed: book.available && !inCart
            ? () {
                ref.read(borrowCartProvider.notifier).addItem(book);
                GlassSnackBar.show(
                  context,
                  'Added to borrow cart!',
                  type: GlassSnackBarType.success,
                  duration: const Duration(seconds: 1),
                );
              }
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: inCart ? AppColors.green : AppColors.navy,
          foregroundColor: AppColors.onPrimary,
          disabledBackgroundColor: AppColors.borderColor,
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

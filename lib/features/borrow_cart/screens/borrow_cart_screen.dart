import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:libratrack_application/features/borrow_cart/screens/request_borrow_screen.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/cart_empty_state.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/cart_info_banner.dart';
import 'package:libratrack_application/features/borrow_cart/widgets/cart_item.dart';
import 'package:provider/provider.dart';

class BorrowCartScreen extends StatelessWidget {
  const BorrowCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<BorrowCartProvider>();
    final isEmpty = cart.items.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(Icons.menu_rounded, color: AppColors.navy, size: 24),
                  SizedBox(width: 12),
                  Text(
                    'Borrow Cart',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.grey),
            Expanded(
              child: isEmpty
                  ? CartEmptyState()
                  : ListView.separated(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      itemCount: cart.items.length + 1,
                      separatorBuilder: (_, index) => index == 0
                          ? const SizedBox(height: 16)
                          : const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Requests',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.navy,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Review the items you wish to borrow from the collection.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          );
                        }
                        final book = cart.items[index - 1];
                        return CartItem(
                          book: book,
                          onRemove: () => cart.removeItem(index - 1),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RequestBorrowScreen(book: book),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const Padding(padding: EdgeInsets.all(20), child: CartInfoBanner()),
          ],
        ),
      ),
    );
  }
}

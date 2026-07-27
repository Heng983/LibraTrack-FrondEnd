import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_notifier.dart';
import 'package:libratrack_application/features/borrow_cart/screens/borrow_cart_screen.dart';
import 'package:libratrack_application/features/history/screens/history_screen.dart';
import 'package:libratrack_application/features/navigation/providers/nav_index_provider.dart';
import 'package:libratrack_application/features/navigation/widgets/badged_icon.dart';
import 'package:libratrack_application/features/profile/screens/profile_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:libratrack_application/features/book_catalog/screens/book_catalog_screen.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  static const List<Widget> _pages = [
    BookCatalogScreen(),
    BorrowCartScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainTabIndexProvider);
    final cartCount = ref.watch(borrowCartProvider.select((s) => s.count));
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        backgroundColor: AppColors.card,
        unselectedItemColor: AppColors.textMuted,
        onTap: (int index) {
          ref.read(mainTabIndexProvider.notifier).set(index);
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.library_books_outlined),
            title: Text("Catalog", style: TextStyle(color: AppColors.teal)),
            selectedColor: AppColors.teal,
          ),
          SalomonBottomBarItem(
            icon: BadgedIcon(icon: Icons.book_outlined, count: cartCount),
            title: Text("My Borrow", style: TextStyle(color: AppColors.teal)),
            selectedColor: AppColors.teal,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.inventory_2_outlined),
            title: Text("History", style: TextStyle(color: AppColors.teal)),
            selectedColor: AppColors.teal,
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person_outline),
            title: Text("Profile", style: TextStyle(color: AppColors.teal)),
            selectedColor: AppColors.teal,
          ),
        ],
      ),
    );
  }
}

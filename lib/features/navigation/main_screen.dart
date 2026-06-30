import 'package:flutter/material.dart';
import 'package:libratrack_application/features/borrow_cart/screens/borrow_cart_screen.dart';
import 'package:libratrack_application/features/history/screens/history_screen.dart';
import 'package:libratrack_application/features/profile/screens/profile_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:libratrack_application/features/book_catalog/screens/book_catalog_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const BookCatalogScreen(),
    const BorrowCartScreen(),
    const HistoryScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.library_books_outlined),
            title: const Text(
              "Catalog",
              style: TextStyle(color: Color(0xFF006F66)),
            ),
            selectedColor: const Color.fromARGB(255, 1, 187, 162),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.book_outlined),
            title: const Text(
              "My Borrow",
              style: TextStyle(color: Color(0xFF006F66)),
            ),
            selectedColor: const Color.fromARGB(255, 1, 187, 162),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.inventory_2_outlined),
            title: const Text(
              "History",
              style: TextStyle(color: Color(0xFF006F66)),
            ),
            selectedColor: const Color.fromARGB(255, 1, 187, 162),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.person_outline),
            title: const Text(
              "Profile",
              style: TextStyle(color: Color(0xFF006F66)),
            ),
            selectedColor: const Color.fromARGB(255, 1, 187, 162),
          ),
        ],
      ),
    );
  }
}

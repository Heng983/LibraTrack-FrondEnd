import 'package:flutter/material.dart';
import 'package:libratrack_application/features/admin/screens/admin_dashboard_screen.dart';
import 'package:libratrack_application/features/admin/screens/admin_profile_screen.dart';
import 'package:libratrack_application/features/admin/screens/borrow_request_screen.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AdminNavigationBar extends StatefulWidget {
  const AdminNavigationBar({super.key});

  @override
  State<AdminNavigationBar> createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends State<AdminNavigationBar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const AdminDashboardScreen(),
    const RequestScreen(),
    const AdminProfileScreen(),
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
            icon: const Icon(Icons.dashboard_outlined),
            title: const Text(
              "Dashboard",
              style: TextStyle(color: Color(0xFF006F66)),
            ),
            selectedColor: const Color.fromARGB(255, 1, 187, 162),
          ),
          SalomonBottomBarItem(
            icon: const Icon(Icons.pending_actions_outlined),
            title: const Text(
              "Request",
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

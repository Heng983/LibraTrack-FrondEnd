import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/admin/providers/borrow_request_notifier.dart';
import 'package:libratrack_application/features/admin/screens/admin_dashboard_screen.dart';
import 'package:libratrack_application/features/admin/screens/admin_profile_screen.dart';
import 'package:libratrack_application/features/admin/screens/borrow_request_screen.dart';
import 'package:libratrack_application/features/navigation/providers/nav_index_provider.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class AdminNavigationBar extends ConsumerStatefulWidget {
  const AdminNavigationBar({super.key});

  @override
  ConsumerState<AdminNavigationBar> createState() => _AdminNavigationBarState();
}

class _AdminNavigationBarState extends ConsumerState<AdminNavigationBar> {
  Timer? _badgeTimer;

  static const List<Widget> _pages = [
    AdminDashboardScreen(),
    RequestScreen(),
    AdminProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Keeps the pending-request badge fresh regardless of which tab the
    // admin is on; silent so it never flashes loading indicators.
    _badgeTimer = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) {
        ref
            .read(borrowRequestProvider.notifier)
            .loadRequests(status: 'pending', silent: true);
      }
    });
  }

  @override
  void dispose() {
    _badgeTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(adminTabIndexProvider);
    final pendingCount = ref.watch(
      borrowRequestProvider.select((s) => s.pendingCount),
    );
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _pages),
      bottomNavigationBar: SalomonBottomBar(
        currentIndex: currentIndex,
        backgroundColor: AppColors.card,
        unselectedItemColor: AppColors.textMuted,
        onTap: (int index) {
          ref.read(adminTabIndexProvider.notifier).set(index);
        },
        items: [
          SalomonBottomBarItem(
            icon: const Icon(Icons.dashboard_outlined),
            title: Text("Dashboard", style: TextStyle(color: AppColors.teal)),
            selectedColor: AppColors.teal,
          ),
          SalomonBottomBarItem(
            icon: _BadgedIcon(
              icon: Icons.pending_actions_outlined,
              count: pendingCount,
            ),
            title: Text("Request", style: TextStyle(color: AppColors.teal)),
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

class _BadgedIcon extends StatelessWidget {
  final IconData icon;
  final int count;

  const _BadgedIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon),
        if (count > 0)
          Positioned(
            top: -6,
            right: -8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              constraints: const BoxConstraints(minWidth: 18),
              decoration: BoxDecoration(
                color: AppColors.red,
                borderRadius: BorderRadius.circular(9),
                border: Border.all(color: AppColors.card, width: 1.5),
              ),
              child: Text(
                count > 99 ? '99+' : '$count',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

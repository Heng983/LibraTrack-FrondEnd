import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_notifier.dart';
import 'package:libratrack_application/features/history/widgets/active_book_card.dart';
import 'package:libratrack_application/features/history/widgets/empty_state.dart';
import 'package:libratrack_application/features/history/widgets/history_app_bar.dart';
import 'package:libratrack_application/features/history/widgets/history_book_card.dart';
import 'package:libratrack_application/features/history/widgets/pending_book_card.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(borrowCartProvider.notifier).fetchMyBorrows();
    });

    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (mounted) ref.read(borrowCartProvider.notifier).fetchMyBorrows();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref.read(borrowCartProvider.notifier).fetchMyBorrows();
  }

  Widget _currentTab(BorrowCartState borrow) {
    switch (_tabController.index) {
      case 0:
        return _ActiveTab(items: borrow.active, onRefresh: _refresh);
      case 1:
        return _HistoryTab(items: borrow.history, onRefresh: _refresh);
      default:
        return _PendingTab(items: borrow.pending, onRefresh: _refresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    final borrow = ref.watch(borrowCartProvider);

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            const HistoryAppBar(),
            Divider(height: 1, color: AppColors.divider),
            Container(
              color: AppColors.bgcolor,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.navy,
                unselectedLabelColor: AppColors.textPrimary,
                labelStyle: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
                indicatorColor: AppColors.navy,
                indicatorWeight: 2,
                tabs: const [
                  Tab(text: 'ACTIVE'),
                  Tab(text: 'HISTORY'),
                  Tab(text: 'PENDING'),
                ],
              ),
            ),
            Expanded(
              child: borrow.isLoading && borrow.myBorrows.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedSwitcher(
                      duration: const Duration(milliseconds: 220),
                      switchInCurve: Curves.easeOut,
                      switchOutCurve: Curves.easeIn,
                      child: KeyedSubtree(
                        key: ValueKey(_tabController.index),
                        child: _currentTab(borrow),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveTab extends StatelessWidget {
  final List<BorrowRecordModel> items;
  final Future<void> Function() onRefresh;

  const _ActiveTab({required this.items, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: EmptyState(message: 'No active borrows'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 1, // +1 for header
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'Currently Borrowed (${items.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            );
          }
          return ActiveBookCard(item: items[index - 1]);
        },
      ),
    );
  }
}

class _HistoryTab extends StatelessWidget {
  final List<BorrowRecordModel> items;
  final Future<void> Function() onRefresh;

  const _HistoryTab({required this.items, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: EmptyState(message: 'No returned books yet'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: items.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Text(
                'Recently Returned (${items.length})',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            );
          }
          return HistoryBookCard(item: items[index - 1]);
        },
      ),
    );
  }
}

class _PendingTab extends ConsumerWidget {
  final List<BorrowRecordModel> items;
  final Future<void> Function() onRefresh;

  const _PendingTab({required this.items, required this.onRefresh});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: onRefresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6,
              child: EmptyState(message: 'No pending requests'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length + 1,
        itemBuilder: (_, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
              child: Text(
                'Awaiting Approval',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
            );
          }
          final item = items[index - 1];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: PendingBookCard(
              item: item,
              onCancel: () async {
                final success = await ref
                    .read(borrowCartProvider.notifier)
                    .cancelRequest(item.id);
                if (success && context.mounted) {
                  GlassSnackBar.show(
                    context,
                    'Request cancelled',
                    type: GlassSnackBarType.success,
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

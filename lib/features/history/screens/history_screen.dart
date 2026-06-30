import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_provider.dart';
import 'package:libratrack_application/features/history/widgets/active_book_card.dart';
import 'package:libratrack_application/features/history/widgets/empty_state.dart';
import 'package:libratrack_application/features/history/widgets/history_app_bar.dart';
import 'package:libratrack_application/features/history/widgets/history_book_card.dart';
import 'package:libratrack_application/features/history/widgets/pending_book_card.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BorrowCartProvider>().fetchMyBorrows();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borrow = context.watch<BorrowCartProvider>();

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          children: [
            // ── App Bar ──
            const HistoryAppBar(),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),

            // ── Tab Bar ──
            Container(
              color: AppColors.bgcolor,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.navy,
                unselectedLabelColor: Colors.black,
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

            // ── Tab Views ──
            Expanded(
              child: borrow.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabController,
                      children: [
                        _ActiveTab(items: borrow.active),
                        _HistoryTab(items: borrow.history),
                        _PendingTab(items: borrow.pending),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Active Tab ──
class _ActiveTab extends StatelessWidget {
  final List<BorrowRecordModel> items;

  const _ActiveTab({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyState(message: 'No active borrows');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            'Currently Borrowed (${items.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) => ActiveBookCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}

// ── History Tab ──
class _HistoryTab extends StatelessWidget {
  final List<BorrowRecordModel> items;

  const _HistoryTab({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyState(message: 'No returned books yet');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            'Recently Returned (${items.length})',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) => HistoryBookCard(item: items[index]),
          ),
        ),
      ],
    );
  }
}

// ── Pending Tab ──
class _PendingTab extends StatelessWidget {
  final List<BorrowRecordModel> items;

  const _PendingTab({required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return EmptyState(message: 'No pending requests');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
          child: Text(
            'Awaiting Approval',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: PendingBookCard(
                  item: item,
                  onCancel: () async {
                    final success = await context
                        .read<BorrowCartProvider>()
                        .cancelRequest(item.id);
                    if (success && context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Request cancelled')),
                      );
                    }
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/admin/models/borrow_request_model.dart';
import 'package:libratrack_application/features/admin/providers/borrow_request_notifier.dart';
import 'package:libratrack_application/features/admin/widgets/request_card.dart';
import 'package:libratrack_application/features/navigation/providers/nav_index_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum RequestSort { newest, oldest, studentId }

class RequestScreen extends ConsumerStatefulWidget {
  const RequestScreen({super.key});

  @override
  ConsumerState<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends ConsumerState<RequestScreen> {
  int _selectedTab = 0;
  Timer? _timer;

  String? get _statusForTab {
    switch (_selectedTab) {
      case 0:
        return 'pending';
      case 2:
        return 'returned';
      case 3:
        return 'approved';
      default:
        return null;
    }
  }

  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  RequestSort _sort = RequestSort.newest;

  List<BorrowRequestModel> get _skeletonRequests => List.generate(
    4,
    (_) => BorrowRequestModel(
      id: 0,
      studentId: 0,
      studentCode: 'B20240000',
      studentName: 'Student name placeholder',
      bookTitle: 'Book title placeholder',
      bookCover: '',
      requestDate: '00/00/0000',
      priority: RequestPriority.standard,
      status: _statusForTab ?? 'pending',
    ),
  );

  List<BorrowRequestModel> _visibleRequests(List<BorrowRequestModel> all) {
    final query = _searchController.text.trim().toLowerCase();
    final filtered = query.isEmpty
        ? all.toList()
        : all
              .where(
                (r) =>
                    r.studentName.toLowerCase().contains(query) ||
                    r.bookTitle.toLowerCase().contains(query) ||
                    r.studentCode.toLowerCase().contains(query),
              )
              .toList();

    switch (_sort) {
      case RequestSort.newest:
        filtered.sort(
          (a, b) => (b.requestedAt ?? DateTime(0)).compareTo(
            a.requestedAt ?? DateTime(0),
          ),
        );
      case RequestSort.oldest:
        filtered.sort(
          (a, b) => (a.requestedAt ?? DateTime(0)).compareTo(
            b.requestedAt ?? DateTime(0),
          ),
        );
      case RequestSort.studentId:
        filtered.sort(
          (a, b) => a.studentCode.toLowerCase().compareTo(
            b.studentCode.toLowerCase(),
          ),
        );
    }
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
    Future.microtask(() {
      ref.read(borrowRequestProvider.notifier).loadRequests(status: 'pending');
    });

    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        ref
            .read(borrowRequestProvider.notifier)
            .loadRequests(status: _statusForTab);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    await ref
        .read(borrowRequestProvider.notifier)
        .loadRequests(status: _statusForTab);
  }

  Future<void> _approve(int id) async {
    final ok = await ref.read(borrowRequestProvider.notifier).approve(id);
    if (!mounted) return;
    GlassSnackBar.show(
      context,
      ok ? 'Request approved!' : 'Failed to approve',
      type: ok ? GlassSnackBarType.success : GlassSnackBarType.error,
    );
  }

  Future<void> _reject(int id) async {
    final ok = await ref.read(borrowRequestProvider.notifier).reject(id);
    if (!mounted) return;
    GlassSnackBar.show(
      context,
      ok ? 'Request rejected.' : 'Failed to reject',
      type: ok ? GlassSnackBarType.info : GlassSnackBarType.error,
    );
  }

  Future<void> _markReturned(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Mark as returned?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'This confirms the student has returned the book to the library.',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Confirm', style: TextStyle(color: AppColors.teal)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final ok = await ref.read(borrowRequestProvider.notifier).markReturned(id);
    if (!mounted) return;
    GlassSnackBar.show(
      context,
      ok ? 'Book marked as returned.' : 'Failed to mark as returned',
      type: ok ? GlassSnackBarType.success : GlassSnackBarType.error,
    );
  }

  String _sortLabel(RequestSort sort) {
    switch (sort) {
      case RequestSort.newest:
        return 'Newest first';
      case RequestSort.oldest:
        return 'Oldest first';
      case RequestSort.studentId:
        return 'Student ID';
    }
  }

  Widget _tabContent(
    BorrowRequestState state,
    List<BorrowRequestModel> tabList,
    List<BorrowRequestModel> visible,
  ) {
    if (state.isLoading && tabList.isEmpty) {
      final placeholders = _skeletonRequests;
      return Skeletonizer(
        effect: ShimmerEffect(
          baseColor: AppColors.fieldBg,
          highlightColor: AppColors.borderColor,
        ),
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: placeholders.length,
          itemBuilder: (_, index) => RequestCard(
            requestModel: placeholders[index],
            onApprove: () {},
            onReject: () {},
          ),
        ),
      );
    }
    if (state.error != null && tabList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Text(state.error!),
        ),
      );
    }
    if (visible.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Icon(
                tabList.isEmpty
                    ? Icons.check_circle_outline
                    : Icons.search_off_rounded,
                size: 56,
                color: AppColors.hintGray,
              ),
              const SizedBox(height: 12),
              Text(
                tabList.isNotEmpty
                    ? 'No matches for your search'
                    : _selectedTab == 0
                    ? 'No pending requests'
                    : _selectedTab == 2
                    ? 'No returned books yet'
                    : _selectedTab == 3
                    ? 'No books currently borrowed'
                    : 'No records found',
                style: TextStyle(fontSize: 15, color: AppColors.textMuted),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: visible.length,
      itemBuilder: (_, index) {
        final req = visible[index];
        return RequestCard(
          requestModel: req,
          onApprove: () => _approve(req.id),
          onReject: () => _reject(req.id),
          onMarkReturned: () => _markReturned(req.id),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Other screens (e.g. the dashboard notification sheet) can request a
    // specific tab; apply it, fetch its data, and reset the request.
    ref.listen<int?>(requestScreenTabProvider, (_, requested) {
      if (requested == null) return;
      setState(() => _selectedTab = requested);
      ref
          .read(borrowRequestProvider.notifier)
          .loadRequests(status: _statusForTab);
      ref.read(requestScreenTabProvider.notifier).clear();
    });

    final state = ref.watch(borrowRequestProvider);
    final tabList = state.listFor(_statusForTab);
    final visible = _visibleRequests(tabList);

    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColors.bgcolor,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Icon(
                    Icons.menu_rounded,
                    color: AppColors.textPrimary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'LibraTrack',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => _searchFocusNode.requestFocus(),
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppColors.navy,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.divider),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Borrow Requests',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Manage incoming loan requests from students and faculty.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.fieldBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            _TabButton(
                              label: 'Pending (${state.pendingCount})',
                              selected: _selectedTab == 0,
                              onTap: () {
                                setState(() => _selectedTab = 0);
                                ref
                                    .read(borrowRequestProvider.notifier)
                                    .loadRequests(status: 'pending');
                              },
                            ),
                            _TabButton(
                              label: 'Borrowed',
                              selected: _selectedTab == 3,
                              onTap: () {
                                setState(() => _selectedTab = 3);
                                ref
                                    .read(borrowRequestProvider.notifier)
                                    .loadRequests(status: 'approved');
                              },
                            ),
                            _TabButton(
                              label: 'Returned',
                              selected: _selectedTab == 2,
                              onTap: () {
                                setState(() => _selectedTab = 2);
                                ref
                                    .read(borrowRequestProvider.notifier)
                                    .loadRequests(status: 'returned');
                              },
                            ),
                            _TabButton(
                              label: 'All',
                              selected: _selectedTab == 1,
                              onTap: () {
                                setState(() => _selectedTab = 1);
                                ref
                                    .read(borrowRequestProvider.notifier)
                                    .loadRequests();
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: AppColors.card,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: AppColors.borderColor,
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                focusNode: _searchFocusNode,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Search name, book, or student ID',
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    color: AppColors.hintGray,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search_rounded,
                                    size: 20,
                                    color: AppColors.hintGray,
                                  ),
                                  suffixIcon: _searchController.text.isNotEmpty
                                      ? IconButton(
                                          icon: Icon(
                                            Icons.close_rounded,
                                            size: 18,
                                            color: AppColors.textMuted,
                                          ),
                                          onPressed: _searchController.clear,
                                        )
                                      : null,
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: AppColors.borderColor),
                            ),
                            child: PopupMenuButton<RequestSort>(
                              initialValue: _sort,
                              color: AppColors.card,
                              onSelected: (value) =>
                                  setState(() => _sort = value),
                              itemBuilder: (_) => RequestSort.values
                                  .map(
                                    (s) => PopupMenuItem(
                                      value: s,
                                      child: Text(
                                        _sortLabel(s),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: s == _sort
                                              ? AppColors.navy
                                              : AppColors.textPrimary,
                                          fontWeight: s == _sort
                                              ? FontWeight.w700
                                              : FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.sort_rounded,
                                      size: 20,
                                      color: AppColors.navy,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _sortLabel(_sort),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 2,
                        child: state.isLoading && tabList.isNotEmpty
                            ? LinearProgressIndicator(
                                minHeight: 2,
                                backgroundColor: Colors.transparent,
                                color: AppColors.teal,
                              )
                            : null,
                      ),
                      const SizedBox(height: 10),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 220),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: KeyedSubtree(
                          key: ValueKey(_selectedTab),
                          child: _tabContent(state, tabList, visible),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? AppColors.card : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? AppColors.textPrimary : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

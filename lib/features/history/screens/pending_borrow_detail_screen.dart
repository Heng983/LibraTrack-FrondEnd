import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';
import 'package:libratrack_application/features/borrow_cart/providers/borrow_cart_notifier.dart';

class PendingBorrowDetailScreen extends ConsumerStatefulWidget {
  final BorrowRecordModel item;

  const PendingBorrowDetailScreen({super.key, required this.item});

  @override
  ConsumerState<PendingBorrowDetailScreen> createState() =>
      _PendingBorrowDetailScreenState();
}

class _PendingBorrowDetailScreenState
    extends ConsumerState<PendingBorrowDetailScreen> {
  bool _cancelling = false;

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  BorrowRecordModel get item => widget.item;

  DateTime? get _requestedAt => item.createdAt ?? item.borrowedAt;

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final d = date.toLocal();
    return '${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  String _formatTime(DateTime date) {
    final d = date.toLocal();
    final hour12 = d.hour % 12 == 0 ? 12 : d.hour % 12;
    final minute = d.minute.toString().padLeft(2, '0');
    final period = d.hour < 12 ? 'AM' : 'PM';
    return '$hour12:$minute $period';
  }

  Future<void> _cancelRequest() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'Cancel this request?',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Cancelling will immediately release the hold on this item.',
          style: TextStyle(color: AppColors.textMuted),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(
              'Keep Request',
              style: TextStyle(color: AppColors.textMuted),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text('Cancel Request', style: TextStyle(color: AppColors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _cancelling = true);
    final success = await ref
        .read(borrowCartProvider.notifier)
        .cancelRequest(item.id);
    if (!mounted) return;
    setState(() => _cancelling = false);

    if (success) {
      Navigator.pop(context);
      GlassSnackBar.show(
        context,
        'Request cancelled',
        type: GlassSnackBarType.success,
      );
    } else {
      GlassSnackBar.show(
        context,
        'Failed to cancel request',
        type: GlassSnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final requested = _requestedAt;
    final estimatedPickup = requested?.add(const Duration(days: 3));

    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Borrow Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 1, color: AppColors.divider),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Status + request id
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.navy.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.navy.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            'PENDING REVIEW',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                              color: AppColors.navy,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'ID: BR-${item.id}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Book card
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: SizedBox(
                              width: double.infinity,
                              height: 300,
                              child: item.book?.cover != null
                                  ? Image.network(
                                      item.book!.cover,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          _coverPlaceholder(),
                                    )
                                  : _coverPlaceholder(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            item.book?.title ?? '',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'By ${item.book?.author ?? ''}',
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              _tag(item.book?.category ?? 'General'),
                              const SizedBox(width: 10),
                              _tag('${item.durationDays}-day loan'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info cards
                    _infoCard(
                      label: 'REQUESTED DATE',
                      value: _formatDate(requested),
                    ),
                    const SizedBox(height: 14),
                    _infoCard(
                      label: 'ESTIMATED PICKUP',
                      value: _formatDate(estimatedPickup),
                    ),
                    const SizedBox(height: 14),
                    _infoCard(label: 'PICKUP LOCATION', value: 'Main Library'),
                    const SizedBox(height: 16),

                    // Process timeline
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.borderColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Process Timeline',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 18),
                          _timelineStep(
                            state: _StepState.done,
                            title: 'Request Submitted',
                            subtitle: requested != null
                                ? '${_formatDate(requested)} • ${_formatTime(requested)}'
                                : 'Submitted',
                          ),
                          _timelineStep(
                            state: _StepState.active,
                            title: 'Librarian Approval',
                            subtitle:
                                'In progress... Usually takes 1-2 business days.',
                          ),
                          _timelineStep(
                            state: _StepState.pending,
                            title: 'Ready for Pickup',
                            subtitle:
                                'Notification will be sent via app & email.',
                            isLast: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Info note
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(6),
                        border: Border(
                          left: BorderSide(color: AppColors.navy, width: 4),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            size: 20,
                            color: AppColors.textMuted,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Your request is being reviewed by the library '
                              'staff. You will receive a notification once it '
                              'is approved and ready for pickup. Access to '
                              'this title is subject to availability and '
                              'account standing.',
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Cancel request
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: _cancelling ? null : _cancelRequest,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.red,
                          side: BorderSide(color: AppColors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        icon: _cancelling
                            ? SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.red,
                                ),
                              )
                            : const Icon(Icons.cancel_outlined, size: 20),
                        label: Text(
                          _cancelling ? 'CANCELLING...' : 'CANCEL REQUEST',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        'Cancelling will immediately release the hold on this item.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.hintGray,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      color: AppColors.fieldBg,
      child: Icon(Icons.book_rounded, size: 56, color: AppColors.textMuted),
    );
  }

  Widget _tag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _infoCard({required String label, required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineStep({
    required _StepState state,
    required String title,
    required String subtitle,
    bool isLast = false,
  }) {
    final Color titleColor;
    final Color subtitleColor;
    final Widget indicator;

    switch (state) {
      case _StepState.done:
        titleColor = AppColors.textPrimary;
        subtitleColor = AppColors.textMuted;
        indicator = Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.teal,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_rounded, size: 18, color: AppColors.onPrimary),
        );
      case _StepState.active:
        titleColor = AppColors.navy;
        subtitleColor = AppColors.textMuted;
        indicator = Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.navy, width: 2),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.navy,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      case _StepState.pending:
        titleColor = AppColors.textPrimary;
        subtitleColor = AppColors.hintGray;
        indicator = Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.borderColor, width: 2),
          ),
        );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              indicator,
              if (!isLast)
                Expanded(
                  child: Container(width: 2, color: AppColors.borderColor),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.4,
                      color: subtitleColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _StepState { done, active, pending }

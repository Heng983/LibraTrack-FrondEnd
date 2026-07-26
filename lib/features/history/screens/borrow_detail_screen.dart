import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/core/widgets/glass_snack_bar.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';

class BorrowDetailScreen extends StatelessWidget {
  final BorrowRecordModel item;

  const BorrowDetailScreen({super.key, required this.item});

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static const _accentIndigo = Color(0xFF5B5FC7);

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    final d = date.toLocal();
    return '${_months[d.month - 1]} ${d.day}, ${d.year}';
  }

  int get _daysUntilDue {
    if (item.dueDate == null) return 99;
    final due = item.dueDate!.toLocal();
    final now = DateTime.now();
    // Compare calendar dates so partial days don't skew the count.
    return DateTime(due.year, due.month, due.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  @override
  Widget build(BuildContext context) {
    final days = _daysUntilDue;
    final isUrgent = days <= 3;
    final dueChipColor = isUrgent ? AppColors.red : AppColors.teal;
    final dueChipText = days < 0
        ? 'Overdue by ${-days} ${days == -1 ? 'day' : 'days'}'
        : days == 0
        ? 'Due today'
        : 'Due in $days ${days == 1 ? 'day' : 'days'}';

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
                    'LibraTrack',
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
                    // Cover
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        width: double.infinity,
                        height: 420,
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
                    const SizedBox(height: 20),

                    // Status chips
                    Row(
                      children: [
                        _chip(
                          icon: Icons.timer_outlined,
                          label: dueChipText,
                          color: dueChipColor,
                        ),
                        const SizedBox(width: 10),
                        _chip(label: 'Active Borrow', color: _accentIndigo),
                      ],
                    ),
                    const SizedBox(height: 18),

                    // Title & author
                    Text(
                      item.book?.title ?? '',
                      style: TextStyle(
                        fontSize: 30,
                        height: 1.2,
                        fontWeight: FontWeight.bold,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.book?.author ?? '',
                      style: TextStyle(
                        fontSize: 19,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _infoCard(
                      label: 'BORROWED DATE',
                      value: _formatDate(item.borrowedAt),
                    ),
                    const SizedBox(height: 14),
                    _infoCard(
                      label: 'DUE DATE',
                      value: _formatDate(item.dueDate),
                      valueColor: AppColors.red,
                    ),
                    const SizedBox(height: 14),
                    _infoCard(label: 'PICKUP LOCATION', value: 'Main Library'),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: () => GlassSnackBar.show(
                          context,
                          'Renewal request sent to the librarian.',
                          type: GlassSnackBarType.success,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.navy,
                          foregroundColor: AppColors.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.refresh_rounded, size: 24),
                        label: const Text(
                          'Renew Loan',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Center(
                      child: Text(
                        'You have 1 renewal left for this item.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Divider(color: AppColors.divider),
                    const SizedBox(height: 20),
                    _outlinedAction(
                      context,
                      icon: Icons.report_gmailerrorred_rounded,
                      label: 'Report Issue',
                      color: AppColors.teal,
                    ),
                    const SizedBox(height: 12),
                    _outlinedAction(
                      context,
                      icon: Icons.forum_outlined,
                      label: 'Contact Librarian',
                      color: AppColors.navy,
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
      color: _accentIndigo.withValues(alpha: 0.25),
      child: Icon(Icons.image_outlined, size: 64, color: _accentIndigo),
    );
  }

  Widget _chip({IconData? icon, required String label, required Color color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.fieldBg,
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
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: valueColor ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlinedAction(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton.icon(
        onPressed: () => GlassSnackBar.show(context, '$label is coming soon.'),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        icon: Icon(icon, size: 20),
        label: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

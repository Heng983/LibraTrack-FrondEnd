import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';
import 'package:libratrack_application/features/history/screens/borrow_detail_screen.dart';

class ActiveBookCard extends StatelessWidget {
  final BorrowRecordModel item;

  const ActiveBookCard({super.key, required this.item});

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
    final dueBadgeColor = isUrgent ? AppColors.red : AppColors.green;
    final dueText = days < 0
        ? 'OVERDUE BY ${-days} ${days == -1 ? 'DAY' : 'DAYS'}'
        : days == 0
        ? 'DUE TODAY'
        : 'DUE IN $days ${days == 1 ? 'DAY' : 'DAYS'}';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cover
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.book?.cover != null
                      ? Image.network(
                          item.book!.cover,
                          width: 90,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _placeholder(),
                        )
                      : _placeholder(),
                ),
                const SizedBox(width: 16),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        item.book?.title ?? '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.book?.author ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            size: 18,
                            color: dueBadgeColor,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            dueText,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: dueBadgeColor,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Borrowed: ${item.borrowedAt?.toLocal().toString().split(' ')[0] ?? ''}',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1, thickness: 1, color: AppColors.divider),

          // Actions
          Container(
            color: AppColors.fieldBg,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BorrowDetailScreen(item: item),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 16,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'DETAILS',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: AppColors.onPrimary,
                    minimumSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'RENEW LOAN',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      width: 90,
      height: 120,
      color: AppColors.fieldBg,
      child: Icon(Icons.book_rounded, color: AppColors.textMuted, size: 32),
    );
  }
}

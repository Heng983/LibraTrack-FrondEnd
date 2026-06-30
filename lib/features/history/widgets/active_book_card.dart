import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';

class ActiveBookCard extends StatelessWidget {
  final BorrowRecordModel item;

  const ActiveBookCard({super.key, required this.item});

  int get _daysUntilDue {
    if (item.dueDate == null) return 99;
    return item.dueDate!.difference(DateTime.now()).inDays;
  }

  @override
  Widget build(BuildContext context) {
    final isUrgent = _daysUntilDue <= 3;
    final dueBadgeColor = isUrgent
        ? const Color(0xFFD32F2F)
        : const Color(0xFF2ECC71);
    final dueText = 'DUE IN $_daysUntilDue DAYS';

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.navy,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.book?.author ?? '',
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color(0xFF888888),
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
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFAAAAAA),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),

          // Actions
          Container(
            color: const Color(0xFFF5F6FA),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'DETAILS',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[800],
                        letterSpacing: 0.6,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
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
      color: const Color(0xFFEAEDF5),
      child: const Icon(Icons.book_rounded, color: Colors.grey, size: 32),
    );
  }
}

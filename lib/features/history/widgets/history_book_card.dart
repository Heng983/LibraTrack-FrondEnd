import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';

class HistoryBookCard extends StatelessWidget {
  final BorrowRecordModel item;

  const HistoryBookCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
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
                          color: Color(0xFF888888),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 18,
                            color: Color(0xFF2ECC71),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'RETURNED ON ${item.returnedAt?.toLocal().toString().split(' ')[0] ?? ''}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2ECC71),
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Borrowed: ${item.borrowedAt?.toLocal().toString().split(' ')[0] ?? ''}',
                        style: TextStyle(
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
          Container(
            color: Color(0xFFF5F6FA),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
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
                const Spacer(),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.navy, width: 1.5),
                    foregroundColor: AppColors.navy,
                    minimumSize: const Size(130, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'RE-BORROW',
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

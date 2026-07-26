import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/admin/models/borrow_request_model.dart';

class RequestCard extends StatelessWidget {
  final BorrowRequestModel requestModel;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback? onMarkReturned;

  const RequestCard({
    super.key,
    required this.requestModel,
    required this.onApprove,
    required this.onReject,
    this.onMarkReturned,
  });

  @override
  Widget build(BuildContext context) {
    final isPriority = requestModel.priority == RequestPriority.priority;
    final isPending = requestModel.status == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.card,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
            child: Image.network(
              requestModel.bookCover,
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 160,
                color: AppColors.fieldBg,
                child: Center(
                  child: Icon(
                    Icons.book_rounded,
                    color: AppColors.textMuted,
                    size: 48,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        requestModel.bookTitle,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isPriority
                            ? AppColors.green.withValues(alpha: 0.15)
                            : AppColors.textMuted.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isPriority ? 'Priority' : 'Standard',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPriority
                              ? AppColors.green
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Requested by : ${requestModel.studentName}',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.navy,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      requestModel.requestDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.badge_outlined,
                      size: 13,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ID: ${requestModel.studentCode.isNotEmpty ? requestModel.studentCode : requestModel.studentId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                if (isPending)
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onApprove,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.navy,
                            foregroundColor: AppColors.onPrimary,
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Approve',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onReject,
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: AppColors.red, width: 1.5),
                            foregroundColor: AppColors.red,
                            minimumSize: const Size.fromHeight(44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Reject',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: _statusBgColor(requestModel.status),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      requestModel.status.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _statusTextColor(requestModel.status),
                      ),
                    ),
                  ),
                  if (requestModel.status == 'approved' &&
                      onMarkReturned != null) ...[
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: onMarkReturned,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.teal, width: 1.5),
                        foregroundColor: AppColors.teal,
                        minimumSize: const Size.fromHeight(44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(
                        Icons.assignment_turned_in_outlined,
                        size: 18,
                      ),
                      label: const Text(
                        'Mark as Returned',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusBgColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.green.withValues(alpha: 0.15);
      case 'rejected':
        return AppColors.red.withValues(alpha: 0.15);
      case 'returned':
        return const Color(0xFF5B5FC7).withValues(alpha: 0.15);
      default:
        return AppColors.textMuted.withValues(alpha: 0.15);
    }
  }

  Color _statusTextColor(String status) {
    switch (status) {
      case 'approved':
        return AppColors.green;
      case 'rejected':
        return AppColors.red;
      case 'returned':
        return const Color(0xFF5B5FC7);
      default:
        return AppColors.textMuted;
    }
  }
}

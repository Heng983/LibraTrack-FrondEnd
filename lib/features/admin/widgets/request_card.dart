import 'package:flutter/material.dart';
import 'package:libratrack_application/core/theme/app_color.dart';
import 'package:libratrack_application/features/admin/models/borrow_request_model.dart';

class RequestCard extends StatelessWidget {
  final BorrowRequestModel requestModel;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  const RequestCard({
    super.key,
    required this.requestModel,
    required this.onApprove,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    final isPriority = requestModel.priority == RequestPriority.priority;
    final isPending = requestModel.status == 'pending';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                color: const Color(0xFFEAEDF5),
                child: const Center(
                  child: Icon(Icons.book_rounded, color: Colors.grey, size: 48),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A2E),
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
                            ? const Color(0xFFE8F8F0)
                            : const Color(0xFFF0F0F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        isPriority ? 'Priority' : 'Standard',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isPriority
                              ? AppColors.green
                              : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Requested by : ${requestModel.studentName}',
                  style: const TextStyle(
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
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      requestModel.requestDate,
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                    const SizedBox(width: 16),
                    Icon(
                      Icons.badge_outlined,
                      size: 13,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'ID: ${requestModel.studentId}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
                            foregroundColor: Colors.white,
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
                            side: const BorderSide(
                              color: AppColors.red,
                              width: 1.5,
                            ),
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
                else
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
        return const Color(0xFFE8F8F0);
      case 'rejected':
        return const Color(0xFFFFEEEE);
      case 'returned':
        return const Color(0xFFEEF0FF);
      default:
        return const Color(0xFFF0F0F0);
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
        return Colors.grey;
    }
  }
}

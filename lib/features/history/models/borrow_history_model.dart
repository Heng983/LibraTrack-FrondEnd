enum BorrowStatus { active, returned, pending }

class BorrowHistoryModel {
  final String title;
  final String author;
  final String cover;
  final BorrowStatus status;
  final String? dueDate;
  final String? borrowedDate;
  final String? returnedDate;
  final int? daysUntilDue;
  final bool eligibleForRenewal;

  const BorrowHistoryModel({
    required this.title,
    required this.author,
    required this.cover,
    required this.status,
    this.dueDate,
    this.borrowedDate,
    this.returnedDate,
    this.daysUntilDue,
    this.eligibleForRenewal = true,
  });
}

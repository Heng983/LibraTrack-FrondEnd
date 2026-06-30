import 'package:libratrack_application/features/book_catalog/models/book_model.dart';

enum BorrowStatus { pending, approved, returned, rejected }

class BorrowRecordModel {
  final int id;
  final int studentId;
  final int bookId;
  final BorrowStatus status;
  final String? reason;
  final int durationDays;
  final DateTime? borrowedAt;
  final DateTime? dueDate;
  final DateTime? returnedAt;
  final BookModel? book;

  BorrowRecordModel({
    required this.id,
    required this.studentId,
    required this.bookId,
    required this.status,
    this.reason,
    required this.durationDays,
    this.borrowedAt,
    this.dueDate,
    this.returnedAt,
    this.book,
  });

  factory BorrowRecordModel.fromJson(Map<String, dynamic> json) {
    return BorrowRecordModel(
      id: json['id'] as int,
      studentId: json['student_id'] as int,
      bookId: json['book_id'] as int,
      status: _parseStatus(json['status'] as String),
      reason: json['reason'] as String?,
      durationDays: json['duration_days'] as int? ?? 14,
      borrowedAt: json['borrowed_at'] != null
          ? DateTime.parse(json['borrowed_at'])
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.parse(json['due_date'])
          : null,
      returnedAt: json['returned_at'] != null
          ? DateTime.parse(json['returned_at'])
          : null,
      book: json['book'] != null ? BookModel.fromJson(json['book']) : null,
    );
  }

  static BorrowStatus _parseStatus(String status) {
    switch (status) {
      case 'approved':
        return BorrowStatus.approved;
      case 'returned':
        return BorrowStatus.returned;
      case 'rejected':
        return BorrowStatus.rejected;
      default:
        return BorrowStatus.pending;
    }
  }
}

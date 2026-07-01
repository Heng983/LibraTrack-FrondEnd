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
      id: json['id'] is int ? json['id'] : int.tryParse('${json['id']}') ?? 0,
      studentId: json['student_id'] is int
          ? json['student_id']
          : int.tryParse('${json['student_id']}') ?? 0,
      bookId: json['book_id'] is int
          ? json['book_id']
          : int.tryParse('${json['book_id']}') ?? 0,
      status: _parseStatus(json['status']?.toString()),
      reason: json['reason']?.toString(),
      durationDays: json['duration_days'] is int
          ? json['duration_days']
          : int.tryParse('${json['duration_days']}') ?? 14,
      borrowedAt: json['borrowed_at'] != null
          ? DateTime.tryParse(json['borrowed_at'].toString())
          : null,
      dueDate: json['due_date'] != null
          ? DateTime.tryParse(json['due_date'].toString())
          : null,
      returnedAt: json['returned_at'] != null
          ? DateTime.tryParse(json['returned_at'].toString())
          : null,
      book: json['book'] != null
          ? BookModel.fromJson(json['book'] as Map<String, dynamic>)
          : null,
    );
  }

  static BorrowStatus _parseStatus(String? status) {
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

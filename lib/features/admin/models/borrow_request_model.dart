import 'package:libratrack_application/core/constants/api_constants.dart';

enum RequestPriority { priority, standard }

class BorrowRequestModel {
  final int id;
  final int studentId;
  final String studentName;
  final String bookTitle;
  final String bookCover;
  final String requestDate;
  final RequestPriority priority;
  final String status;

  BorrowRequestModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.bookTitle,
    required this.bookCover,
    required this.requestDate,
    required this.priority,
    required this.status,
  });

  factory BorrowRequestModel.fromJson(Map<String, dynamic> json) {
    final book = json['book'] as Map<String, dynamic>?;
    final student = json['student'] as Map<String, dynamic>?;

    return BorrowRequestModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentName: student?['name'] ?? 'Unknown',
      bookTitle: book?['title'] ?? 'Unknown',
      bookCover: ApiConstants.proxyCover(book?['cover'] as String?), // ← fixed
      requestDate: _formatDate(json['created_at']),
      priority: RequestPriority.standard,
      status: json['status'] ?? 'pending',
    );
  }

  static String _formatDate(dynamic value) {
    if (value == null) return '';
    final dt = DateTime.tryParse(value.toString());
    if (dt == null) return value.toString();
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

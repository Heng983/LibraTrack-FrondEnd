import 'package:libratrack_application/core/constants/api_constants.dart';

enum RequestPriority { priority, standard }

class BorrowRequestModel {
  final int id;
  final int studentId;

  /// University ID code (e.g. "B20247832"), from the student record.
  final String studentCode;
  final String studentName;
  final String bookTitle;
  final String bookCover;
  final String requestDate;
  final DateTime? requestedAt;
  final RequestPriority priority;
  final String status;

  BorrowRequestModel({
    required this.id,
    required this.studentId,
    this.studentCode = '',
    required this.studentName,
    required this.bookTitle,
    required this.bookCover,
    required this.requestDate,
    this.requestedAt,
    required this.priority,
    required this.status,
  });

  BorrowRequestModel copyWith({String? status}) {
    return BorrowRequestModel(
      id: id,
      studentId: studentId,
      studentCode: studentCode,
      studentName: studentName,
      bookTitle: bookTitle,
      bookCover: bookCover,
      requestDate: requestDate,
      requestedAt: requestedAt,
      priority: priority,
      status: status ?? this.status,
    );
  }

  factory BorrowRequestModel.fromJson(Map<String, dynamic> json) {
    final book = json['book'] as Map<String, dynamic>?;
    final student = json['student'] as Map<String, dynamic>?;

    return BorrowRequestModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentCode: student?['student_id']?.toString() ?? '',
      studentName: student?['name'] ?? 'Unknown',
      bookTitle: book?['title'] ?? 'Unknown',
      bookCover: ApiConstants.proxyCover(book?['cover'] as String?),
      requestDate: _formatDate(json['created_at']),
      requestedAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
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

class DashboardModel {
  final int totalBooks;
  final int availableBooks;
  final int activeBorrows;
  final int overdueCount;
  final int pendingRequests;
  final int totalStudents;

  DashboardModel({
    required this.totalBooks,
    required this.availableBooks,
    required this.activeBorrows,
    required this.overdueCount,
    required this.pendingRequests,
    required this.totalStudents,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalBooks: json['total_books'] ?? 0,
      availableBooks: json['available_books'] ?? 0,
      activeBorrows: json['active_borrows'] ?? 0,
      overdueCount: json['overdue_count'] ?? 0,
      pendingRequests: json['pending_requests'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
    );
  }
}

enum ActivityType { request, returned, system }

class ActivityModel {
  final int id;
  final String message;
  final String timeAgo;
  final ActivityType type;

  ActivityModel({
    required this.id,
    required this.message,
    required this.timeAgo,
    required this.type,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      timeAgo: json['time_ago'] ?? '',
      type: _typeFromStatus(json['status']),
    );
  }
  static ActivityType _typeFromStatus(String? status) {
    switch (status) {
      case 'returned':
        return ActivityType.returned;
      case 'pending':
        return ActivityType.request;
      case 'approved':
      case 'rejected':
      default:
        return ActivityType.system;
    }
  }
}

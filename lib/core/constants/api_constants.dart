import 'package:libratrack_application/core/utils/base_url.dart';

class ApiConstants {
  static String baseUrl = Baseurl.base;

  // auth
  static String studentRegister = '$baseUrl/auth/student/register';
  static String studentLogin = '$baseUrl/auth/student/login';
  static String adminLogin = '$baseUrl/auth/admin/login';
  static String forgotPassword = '$baseUrl/auth/forgot-password';
  static String verifyOtp = '$baseUrl/auth/verify-otp';
  static String resetPassword = '$baseUrl/auth/reset-password';
  static String logout = '$baseUrl/auth/logout';
  static String me = '$baseUrl/auth/me';
  static String updateProfile = '$baseUrl/auth/profile';

  // book
  static String books = '$baseUrl/books';
  static String bookDetail(int id) => '$baseUrl/books/$id';

  // borrows
  static String borrows = '$baseUrl/borrows';
  static String myBorrows = '$baseUrl/borrows/my';
  static String borrowApprove(int id) => '$baseUrl/borrows/$id/approve';
  static String borrowReject(int id) => '$baseUrl/borrows/$id/reject';
  static String borrowReturned(int id) => '$baseUrl/borrows/$id/returned';
  static String borrowCancel(int id) => '$baseUrl/borrows/$id';

  // image
  static String profileImage = '$baseUrl/auth/profile-image';

  // dashboard
  static String dashboard = '$baseUrl/dashboard';
  static String dashboardActivity = '$baseUrl/dashboard/activity';

  // book cover proxy
  static String proxyCover(String? url) {
    if (url == null || url.isEmpty) return '';
    final encoded = Uri.encodeComponent(url);
    return '$baseUrl/book-cover?url=$encoded';
  }
}

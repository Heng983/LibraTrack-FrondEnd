import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/auth/models/admin_model.dart';
import 'package:libratrack_application/features/auth/models/student_model.dart';

class AuthState {
  final StudentModel? student;
  final AdminModel? admin;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.student,
    this.admin,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isLoggedIn => student != null || admin != null;

  AuthState copyWith({
    StudentModel? student,
    AdminModel? admin,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearStudent = false,
    bool clearAdmin = false,
  }) {
    return AuthState(
      student: clearStudent ? null : (student ?? this.student),
      admin: clearAdmin ? null : (admin ?? this.admin),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState();

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> register({
    required String name,
    required String studentId,
    required String email,
    required String department,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.post(ApiConstants.studentRegister, {
        'name': name,
        'student_id': studentId,
        'email': email,
        'department': department,
        'password': password,
        'password_confirmation': password,
      });
      if (response['token'] != null) {
        await ApiService.saveToken(response['token']);
        await ApiService.saveRole('student');
        state = state.copyWith(isLoading: false);
        return true;
      }
      state = state.copyWith(
        errorMessage: response['message'] ?? 'Registration failed',
        isLoading: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> studentLogin({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.post(ApiConstants.studentLogin, {
        'email': email,
        'password': password,
      });
      if (response['token'] != null) {
        await ApiService.saveToken(response['token']);
        await ApiService.saveRole('student');
        state = state.copyWith(
          student: StudentModel.fromJson(response['student']),
          isLoading: false,
        );
        return true;
      }
      state = state.copyWith(
        errorMessage: response['message'] ?? 'Login failed',
        isLoading: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> adminLogin({
    required String adminId,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.post(ApiConstants.adminLogin, {
        'admin_id': adminId,
        'password': password,
      });
      if (response['token'] != null) {
        await ApiService.saveToken(response['token']);
        await ApiService.saveRole('admin');
        state = state.copyWith(
          admin: AdminModel.fromJson(response['admin']),
          isLoading: false,
        );
        return true;
      }
      state = state.copyWith(
        errorMessage: response['message'] ?? 'Login failed',
        isLoading: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> forgotPassword(String email) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.post(ApiConstants.forgotPassword, {
        'email': email,
      });
      state = state.copyWith(
        errorMessage: response['message'],
        isLoading: false,
      );
      return response['message'] == 'OTP sent to your email';
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.post(ApiConstants.verifyOtp, {
        'email': email,
        'otp': otp,
      });
      state = state.copyWith(
        errorMessage: response['message'],
        isLoading: false,
      );
      return response['message'] == 'OTP verified successfully';
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
      return false;
    }
  }

  Future<bool> resetPassword(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final response = await ApiService.put(ApiConstants.resetPassword, {
        'email': email,
        'password': password,
        'password_confirmation': password,
      });
      state = state.copyWith(
        errorMessage: response['message'],
        isLoading: false,
      );
      return response['message'] == 'Password reset successfully';
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
      return false;
    }
  }

  Future<void> loadCurrentUser() async {
    try {
      final res = await ApiService.getAuth(ApiConstants.me);
      final role = await ApiService.getRole();

      if (role == 'student' && res['student'] != null) {
        state = state.copyWith(student: StudentModel.fromJson(res['student']));
      } else if (role == 'admin' && res['student'] != null) {
        state = state.copyWith(admin: AdminModel.fromJson(res['student']));
      }
    } catch (e) {}
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await ApiService.deleteAuth(ApiConstants.logout);
      await ApiService.clearStorage();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(errorMessage: 'Logout failed', isLoading: false);
    }
  }

  Future<bool> uploadProfileImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 500,
        maxHeight: 500,
      );

      if (image == null) return false;

      state = state.copyWith(isLoading: true);

      final token = await ApiService.getToken();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstants.profileImage),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.headers['Accept'] = 'application/json';
      request.files.add(await http.MultipartFile.fromPath('image', image.path));

      final response = await request.send();
      final body = await response.stream.bytesToString();
      final json = jsonDecode(body);

      if (response.statusCode == 200 && json['profile_image'] != null) {
        final s = state.student;
        if (s != null) {
          state = state.copyWith(
            student: StudentModel(
              id: s.id,
              name: s.name,
              studentId: s.studentId,
              email: s.email,
              department: s.department,
              profileImage: json['profile_image'],
            ),
            isLoading: false,
          );
        } else {
          state = state.copyWith(isLoading: false);
        }
        return true;
      }

      state = state.copyWith(isLoading: false);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      return false;
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? department,
    String? password,
    String? passwordConfirmation,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final body = <String, dynamic>{};
      if (name != null && name.isNotEmpty) body['name'] = name;
      if (department != null) body['department'] = department;
      if (password != null && password.isNotEmpty) {
        body['password'] = password;
        body['password_confirmation'] = passwordConfirmation;
      }

      final res = await ApiService.put(
        ApiConstants.updateProfile,
        body,
        auth: true,
      );

      if (res['student'] != null) {
        state = state.copyWith(
          student: StudentModel.fromJson(res['student']),
          isLoading: false,
        );
        return true;
      }

      state = state.copyWith(
        errorMessage: res['message'] ?? 'Failed to update profile',
        isLoading: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Something went wrong',
        isLoading: false,
      );
      return false;
    }
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

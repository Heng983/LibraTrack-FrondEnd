import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/auth/models/admin_model.dart';
import 'package:libratrack_application/features/auth/models/student_model.dart';

class AuthProvider extends ChangeNotifier {
  StudentModel? _student;
  AdminModel? _admin;
  bool _isLoading = false;
  String? _errorMessage;

  StudentModel? get student => _student;
  AdminModel? get admin => _admin;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _student != null || _admin != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> register({
    required String name,
    required String studentId,
    required String email,
    required String department,
    required String password,
  }) async {
    _setLoading(true);
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
        notifyListeners();
        return true;
      }
      _errorMessage = response['message'] ?? 'Registration failed';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Something went wrong";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> studentLogin({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final response = await ApiService.post(ApiConstants.studentLogin, {
        'email': email,
        'password': password,
      });
      if (response['token'] != null) {
        await ApiService.saveToken(response['token']);
        await ApiService.saveRole('student');
        _student = StudentModel.fromJson(response['student']);
        notifyListeners();
        return true;
      }

      _errorMessage = response['message'] ?? "Login failed";
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Something went wrong";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> adminLogin({
    required String adminId,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final response = await ApiService.post(ApiConstants.adminLogin, {
        'admin_id': adminId,
        'password': password,
      });

      if (response['token'] != null) {
        await ApiService.saveToken(response['token']);
        await ApiService.saveRole('admin');
        _admin = AdminModel.fromJson(response['admin']);
        notifyListeners();
        return true;
      }

      _errorMessage = response['message'] ?? "Login failed";
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = "Something went wrong";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> forgotPassword(String email) async {
    _setLoading(true);
    try {
      final response = await ApiService.post(ApiConstants.forgotPassword, {
        "email": email,
      });
      _errorMessage = response["message"];
      notifyListeners();
      return response["message"] == "OTP sent to your email";
    } catch (e) {
      _errorMessage = "Something went wrong";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    _setLoading(true);
    try {
      final response = await ApiService.post(ApiConstants.verifyOtp, {
        "email": email,
        "otp": otp,
      });
      _errorMessage = response["message"];
      notifyListeners();
      return response["message"] == "OTP verified successfully";
    } catch (e) {
      _errorMessage = "Something went wrong";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> resetPassword(String email, String password) async {
    _setLoading(true);
    try {
      final response = await ApiService.put(ApiConstants.resetPassword, {
        "email": email,
        "password": password,
        "password_confirmation": password,
      });
      _errorMessage = response["message"];
      notifyListeners();
      return response["message"] == "Password reset successfully";
    } catch (e) {
      _errorMessage = "Something went wrong";
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadCurrentUser() async {
    try {
      final res = await ApiService.getAuth(ApiConstants.me);
      final role = await ApiService.getRole();

      if (role == 'student' && res['student'] != null) {
        _student = StudentModel.fromJson(res['student']);
        notifyListeners();
      } else if (role == 'admin' && res['student'] != null) {
        _admin = AdminModel.fromJson(res['student']);
        notifyListeners();
      }
    } catch (e) {
      print('Failed to load current user: $e');
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await ApiService.deleteAuth(ApiConstants.logout);
      await ApiService.clearStorage();
      _student = null;
      _admin = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = "Logout failed";
      notifyListeners();
    } finally {
      _setLoading(false);
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

      _setLoading(true);

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
        if (_student != null) {
          _student = StudentModel(
            id: _student!.id,
            name: _student!.name,
            studentId: _student!.studentId,
            email: _student!.email,
            department: _student!.department,
            profileImage: json['profile_image'],
          );
          notifyListeners();
        }
        return true;
      }

      return false;
    } catch (e) {
      print('Upload error: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateProfile({
    String? name,
    String? department,
    String? password,
    String? passwordConfirmation,
  }) async {
    _setLoading(true);
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
        _student = StudentModel.fromJson(res['student']);
        notifyListeners();
        return true;
      }

      _errorMessage = res['message'] ?? 'Failed to update profile';
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'Something went wrong';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }
}

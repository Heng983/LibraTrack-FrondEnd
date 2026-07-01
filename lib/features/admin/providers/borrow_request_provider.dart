import 'package:flutter/material.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/admin/models/borrow_request_model.dart';

class BorrowRequestProvider extends ChangeNotifier {
  List<BorrowRequestModel> requests = [];
  int pendingCount = 0;
  bool isLoading = false;
  String? error;

  Future<void> loadRequests({String? status}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final url = status != null
          ? '${ApiConstants.borrows}?status=$status'
          : ApiConstants.borrows;

      final res = await ApiService.getAuth(url);
      final list = res['borrows'] as List<dynamic>? ?? [];
      requests = list.map((e) => BorrowRequestModel.fromJson(e)).toList();
      if (status == 'pending') {
        pendingCount = requests.length;
      }
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<bool> approve(int id) async {
    try {
      final res = await ApiService.put(
        ApiConstants.borrowApprove(id),
        {},
        auth: true,
      );
      if (res.containsKey('borrow')) {
        requests.removeWhere((r) => r.id == id);
        if (pendingCount > 0) pendingCount--;
        notifyListeners();
        return true;
      }
      error = res['message']?.toString();
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> reject(int id) async {
    try {
      final res = await ApiService.put(
        ApiConstants.borrowReject(id),
        {},
        auth: true,
      );
      if (res.containsKey('borrow')) {
        requests.removeWhere((r) => r.id == id);
        if (pendingCount > 0) pendingCount--;
        notifyListeners();
        return true;
      }
      error = res['message']?.toString();
      notifyListeners();
      return false;
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return false;
    }
  }
}

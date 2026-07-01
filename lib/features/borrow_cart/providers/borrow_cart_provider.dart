import 'package:flutter/material.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';

class BorrowCartProvider extends ChangeNotifier {
  final List<BookModel> _items = [];

  List<BookModel> get items => _items;
  int get count => _items.length;

  void addItem(BookModel book) {
    final exists = _items.any((b) => b.id == book.id);
    if (!exists) {
      _items.add(book);
      notifyListeners();
    }
  }

  void removeItem(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  bool contains(BookModel book) => _items.any((b) => b.id == book.id);

  void clear() {
    _items.clear();
    notifyListeners();
  }

  List<BorrowRecordModel> _myBorrows = [];
  bool _isLoading = false;
  String? _error;

  List<BorrowRecordModel> get myBorrows => _myBorrows;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<BorrowRecordModel> get pending =>
      _myBorrows.where((b) => b.status == BorrowStatus.pending).toList();

  List<BorrowRecordModel> get active =>
      _myBorrows.where((b) => b.status == BorrowStatus.approved).toList();

  List<BorrowRecordModel> get history =>
      _myBorrows.where((b) => b.status == BorrowStatus.returned).toList();

  Future<bool> requestBorrow({
    required int bookId,
    String? reason,
    int durationDays = 14,
  }) async {
    _setLoading(true);
    try {
      final res = await ApiService.postAuth(
        ApiConstants.borrows,
        body: {
          'book_id': bookId,
          'reason': reason,
          'duration_days': durationDays,
        },
      );

      if (res['borrow'] != null) {
        final borrow = BorrowRecordModel.fromJson(res['borrow']);
        _myBorrows.insert(0, borrow);
        notifyListeners();
        return true;
      }

      _error = res['message'] ?? 'Failed to submit request';
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Something went wrong';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchMyBorrows({String? status}) async {
    _setLoading(true);
    try {
      String url = ApiConstants.myBorrows;
      if (status != null) url += '?status=$status';

      final res = await ApiService.getAuth(url);
      print('RAW BORROWS: ${res['borrows']}');
      final dynamic data = res['borrows'];
      if (data is List) {
        _myBorrows = data
            .map((e) => BorrowRecordModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        _myBorrows = [];
      }
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load borrows';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> cancelRequest(int borrowId) async {
    _setLoading(true);
    try {
      final res = await ApiService.deleteAuth(
        ApiConstants.borrowCancel(borrowId),
      );

      if (res['message'] == 'Request cancelled successfully') {
        _myBorrows.removeWhere((b) => b.id == borrowId);
        notifyListeners();
        return true;
      }

      _error = res['message'];
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Something went wrong';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

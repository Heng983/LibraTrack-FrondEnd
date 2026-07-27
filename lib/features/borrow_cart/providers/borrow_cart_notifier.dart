import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/book_catalog/models/book_model.dart';
import 'package:libratrack_application/features/borrow_cart/models/borrow_record_model.dart';

class BorrowCartState {
  final List<BookModel> cartItems;
  final List<BorrowRecordModel> myBorrows;
  final bool isLoading;
  final String? error;

  const BorrowCartState({
    this.cartItems = const [],
    this.myBorrows = const [],
    this.isLoading = false,
    this.error,
  });

  int get count => cartItems.length;

  List<BorrowRecordModel> get pending =>
      myBorrows.where((b) => b.status == BorrowStatus.pending).toList();

  List<BorrowRecordModel> get active =>
      myBorrows.where((b) => b.status == BorrowStatus.approved).toList();

  List<BorrowRecordModel> get history =>
      myBorrows.where((b) => b.status == BorrowStatus.returned).toList();

  BorrowCartState copyWith({
    List<BookModel>? cartItems,
    List<BorrowRecordModel>? myBorrows,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return BorrowCartState(
      cartItems: cartItems ?? this.cartItems,
      myBorrows: myBorrows ?? this.myBorrows,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class BorrowCartNotifier extends Notifier<BorrowCartState> {
  static const _cartPrefsKey = 'borrow_cart_items';

  @override
  BorrowCartState build() {
    Future.microtask(_restoreCart);
    return const BorrowCartState();
  }

  Future<void> _restoreCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_cartPrefsKey);
      if (raw == null) return;

      final saved = (jsonDecode(raw) as List)
          .map((e) => BookModel.fromCache(e as Map<String, dynamic>))
          .toList();
      if (saved.isEmpty) return;

      final current = state.cartItems;
      final merged = [
        ...saved,
        ...current.where((c) => !saved.any((s) => s.id == c.id)),
      ];
      state = state.copyWith(cartItems: merged);
    } catch (_) {}
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _cartPrefsKey,
      jsonEncode(state.cartItems.map((b) => b.toJson()).toList()),
    );
  }

  void addItem(BookModel book) {
    final exists = state.cartItems.any((b) => b.id == book.id);
    if (!exists) {
      state = state.copyWith(cartItems: [...state.cartItems, book]);
      _saveCart();
    }
  }

  void removeItem(int index) {
    final updated = [...state.cartItems]..removeAt(index);
    state = state.copyWith(cartItems: updated);
    _saveCart();
  }

  bool contains(BookModel book) => state.cartItems.any((b) => b.id == book.id);

  void clearCart() {
    state = state.copyWith(cartItems: []);
    _saveCart();
  }

  void clearError() {
    state = state.copyWith(clearError: true);
  }

  Future<bool> requestBorrow({
    required int bookId,
    String? reason,
    int durationDays = 14,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
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
        state = state.copyWith(
          myBorrows: [borrow, ...state.myBorrows],
          isLoading: false,
        );
        return true;
      }

      state = state.copyWith(
        error: res['message'] ?? 'Failed to submit request',
        isLoading: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Something went wrong', isLoading: false);
      return false;
    }
  }

  Future<void> fetchMyBorrows({String? status}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      String url = ApiConstants.myBorrows;
      if (status != null) url += '?status=$status';

      final res = await ApiService.getAuth(url);
      final dynamic data = res['borrows'];

      final borrows = data is List
          ? data
                .map(
                  (e) => BorrowRecordModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : <BorrowRecordModel>[];

      state = state.copyWith(myBorrows: borrows, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: 'Failed to load borrows', isLoading: false);
    }
  }

  Future<bool> cancelRequest(int borrowId) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final res = await ApiService.deleteAuth(
        ApiConstants.borrowCancel(borrowId),
      );

      if (res['message'] == 'Request cancelled successfully') {
        state = state.copyWith(
          myBorrows: state.myBorrows.where((b) => b.id != borrowId).toList(),
          isLoading: false,
        );
        return true;
      }

      state = state.copyWith(
        error: res['message']?.toString(),
        isLoading: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(error: 'Something went wrong', isLoading: false);
      return false;
    }
  }
}

final borrowCartProvider =
    NotifierProvider<BorrowCartNotifier, BorrowCartState>(
      BorrowCartNotifier.new,
    );

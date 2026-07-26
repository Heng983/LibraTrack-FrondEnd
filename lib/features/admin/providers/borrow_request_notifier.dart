import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/admin/models/borrow_request_model.dart';

class BorrowRequestState {
  /// Cached request lists per tab, keyed by status ('pending', 'returned')
  /// or 'all' for the unfiltered list. Keeping them separate means switching
  /// tabs shows the cached list instantly while a refresh runs behind it.
  final Map<String, List<BorrowRequestModel>> byStatus;
  final int pendingCount;
  final bool isLoading;
  final String? error;

  const BorrowRequestState({
    this.byStatus = const {},
    this.pendingCount = 0,
    this.isLoading = false,
    this.error,
  });

  List<BorrowRequestModel> listFor(String? status) =>
      byStatus[status ?? 'all'] ?? const [];

  BorrowRequestState copyWith({
    Map<String, List<BorrowRequestModel>>? byStatus,
    int? pendingCount,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return BorrowRequestState(
      byStatus: byStatus ?? this.byStatus,
      pendingCount: pendingCount ?? this.pendingCount,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class BorrowRequestNotifier extends Notifier<BorrowRequestState> {
  @override
  BorrowRequestState build() => const BorrowRequestState(isLoading: true);

  /// [silent] refreshes the data without toggling [isLoading], so background
  /// polls (e.g. the nav-bar badge) don't flash loading indicators on screen.
  Future<void> loadRequests({String? status, bool silent = false}) async {
    if (!silent) {
      state = state.copyWith(isLoading: true, clearError: true);
    }

    try {
      final url = status != null
          ? '${ApiConstants.borrows}?status=$status'
          : ApiConstants.borrows;

      final res = await ApiService.getAuth(url);
      final list = res['borrows'] as List<dynamic>? ?? [];
      final requests = list.map((e) => BorrowRequestModel.fromJson(e)).toList();

      // The unfiltered list also reveals the pending total, so the badge
      // stays fresh no matter which tab is being polled.
      final pendingCount = status == 'pending'
          ? requests.length
          : status == null
          ? requests.where((r) => r.status == 'pending').length
          : state.pendingCount;

      state = state.copyWith(
        byStatus: {...state.byStatus, status ?? 'all': requests},
        pendingCount: pendingCount,
        isLoading: false,
      );
    } catch (e) {
      if (!silent) {
        state = state.copyWith(error: e.toString(), isLoading: false);
      }
    }
  }

  /// Applies a status change to every cached list: updates the record in
  /// place and drops it from status-filtered lists it no longer belongs to.
  Map<String, List<BorrowRequestModel>> _applyStatus(int id, String newStatus) {
    return state.byStatus.map((key, list) {
      var updated = list
          .map((r) => r.id == id ? r.copyWith(status: newStatus) : r)
          .toList();
      if (key != 'all' && key != newStatus) {
        updated = updated.where((r) => r.id != id).toList();
      }
      return MapEntry(key, updated);
    });
  }

  Future<bool> approve(int id) async {
    try {
      final res = await ApiService.put(
        ApiConstants.borrowApprove(id),
        {},
        auth: true,
      );
      if (res.containsKey('borrow')) {
        state = state.copyWith(
          byStatus: _applyStatus(id, 'approved'),
          pendingCount: state.pendingCount > 0 ? state.pendingCount - 1 : 0,
        );
        return true;
      }
      state = state.copyWith(error: res['message']?.toString());
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
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
        state = state.copyWith(
          byStatus: _applyStatus(id, 'rejected'),
          pendingCount: state.pendingCount > 0 ? state.pendingCount - 1 : 0,
        );
        return true;
      }
      state = state.copyWith(error: res['message']?.toString());
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }

  Future<bool> markReturned(int id) async {
    try {
      final res = await ApiService.put(
        ApiConstants.borrowReturned(id),
        {},
        auth: true,
      );
      if (res.containsKey('borrow')) {
        state = state.copyWith(byStatus: _applyStatus(id, 'returned'));
        return true;
      }
      state = state.copyWith(error: res['message']?.toString());
      return false;
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return false;
    }
  }
}

final borrowRequestProvider =
    NotifierProvider<BorrowRequestNotifier, BorrowRequestState>(
      BorrowRequestNotifier.new,
    );

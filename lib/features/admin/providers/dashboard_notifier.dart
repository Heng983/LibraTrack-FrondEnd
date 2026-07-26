import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:libratrack_application/core/constants/api_constants.dart';
import 'package:libratrack_application/core/services/api_service.dart';
import 'package:libratrack_application/features/admin/models/dashboard_model.dart';

class DashboardState {
  final DashboardModel? dashboard;
  final List<ActivityModel> activities;
  final bool isLoading;
  final String? error;

  const DashboardState({
    this.dashboard,
    this.activities = const [],
    this.isLoading = false,
    this.error,
  });

  DashboardState copyWith({
    DashboardModel? dashboard,
    List<ActivityModel>? activities,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      dashboard: dashboard ?? this.dashboard,
      activities: activities ?? this.activities,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

class DashboardNotifier extends Notifier<DashboardState> {
  @override
  DashboardState build() => const DashboardState();

  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final statsRes = await ApiService.getAuth(ApiConstants.dashboard);
      final stats = statsRes['stats'];

      DashboardModel? dashboard;
      String? error;

      if (stats != null) {
        dashboard = DashboardModel.fromJson(stats);
      } else {
        error = statsRes['message']?.toString() ?? 'No stats';
      }

      final actRes = await ApiService.getAuth(ApiConstants.dashboardActivity);
      final list = actRes['activities'] as List<dynamic>? ?? [];
      final activities = list.map((e) => ActivityModel.fromJson(e)).toList();

      state = state.copyWith(
        dashboard: dashboard ?? state.dashboard,
        activities: activities,
        error: error,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, DashboardState>(
  DashboardNotifier.new,
);

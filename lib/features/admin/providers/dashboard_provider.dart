import 'package:flutter/material.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/services/api_service.dart';
import '../models/dashboard_model.dart';

class DashboardProvider extends ChangeNotifier {
  DashboardModel? dashboard;
  List<ActivityModel> activities = [];
  bool isLoading = false;
  String? error;

  Future<void> loadDashboard() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final statsRes = await ApiService.getAuth(ApiConstants.dashboard);
      final stats = statsRes['stats'];
      if (stats != null) {
        dashboard = DashboardModel.fromJson(stats);
      } else {
        error = statsRes['message']?.toString() ?? 'No stats';
      }
      final actRes = await ApiService.getAuth(ApiConstants.dashboardActivity);
      final list = actRes['activities'] as List<dynamic>? ?? [];
      activities = list.map((e) => ActivityModel.fromJson(e)).toList();
    } catch (e) {
      error = e.toString();
    }

    isLoading = false;
    notifyListeners();
  }
}

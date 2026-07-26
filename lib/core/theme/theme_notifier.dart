import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libratrack_application/core/theme/app_color.dart';

class ThemeNotifier extends Notifier<bool> {
  static const _prefKey = 'dark_mode';

  @override
  bool build() {
    _loadSaved();
    return AppColors.isDark;
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getBool(_prefKey);
    if (saved != null && saved != state) {
      AppColors.isDark = saved;
      state = saved;
    }
  }

  Future<void> toggle() async {
    AppColors.isDark = !state;
    state = AppColors.isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefKey, state);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, bool>(ThemeNotifier.new);

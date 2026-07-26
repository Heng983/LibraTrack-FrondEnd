import 'package:flutter/material.dart';

class LightModeColors {
  static const bgcolor = Color(0xFFE8EDF5);
  static const navy = Color(0xFF1E3A8A);
  static const teal = Color(0xFF0D9488);
  static const bgGray = Color(0xFFF0F2F8);
  static const fieldBg = Color(0xFFEAEDF5);
  static const hintGray = Color(0xFF9AA3B8);
  static const borderColor = Color(0xFFD0D5E8);
  static const card = Color(0xFFFFFFFF);
  static const onPrimary = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF111827);
  static const textMuted = Color(0xFF6B7280);
  static const divider = Color(0xFFBFC7D9);
}

class DarkModeColors {
  static const bgcolor = Color(0xFF0D1524);
  static const primary = Color(0xFF8ECDF6);
  static const teal = Color(0xFF2DD4BF);
  static const bgGray = Color(0xFF0D1524);
  static const fieldBg = Color(0xFF1B2638);
  static const hintGray = Color(0xFF6B7690);
  static const borderColor = Color(0xFF2B3A55);
  static const card = Color(0xFF162030);
  static const onPrimary = Color(0xFF0D1524);
  static const textPrimary = Color(0xFFE6EBF4);
  static const textMuted = Color(0xFF8A94A8);
  static const divider = Color(0xFF263450);
}

class AppColors {
  static bool isDark = false;

  static Color get bgcolor =>
      isDark ? DarkModeColors.bgcolor : LightModeColors.bgcolor;

  static Color get navy =>
      isDark ? DarkModeColors.primary : LightModeColors.navy;

  static Color get teal => isDark ? DarkModeColors.teal : LightModeColors.teal;

  static Color get bgGray =>
      isDark ? DarkModeColors.bgGray : LightModeColors.bgGray;

  static Color get fieldBg =>
      isDark ? DarkModeColors.fieldBg : LightModeColors.fieldBg;

  static Color get hintGray =>
      isDark ? DarkModeColors.hintGray : LightModeColors.hintGray;

  static Color get borderColor =>
      isDark ? DarkModeColors.borderColor : LightModeColors.borderColor;

  static Color get card => isDark ? DarkModeColors.card : LightModeColors.card;

  static Color get onPrimary =>
      isDark ? DarkModeColors.onPrimary : LightModeColors.onPrimary;

  static Color get textPrimary =>
      isDark ? DarkModeColors.textPrimary : LightModeColors.textPrimary;

  static Color get textMuted =>
      isDark ? DarkModeColors.textMuted : LightModeColors.textMuted;

  static Color get divider =>
      isDark ? DarkModeColors.divider : LightModeColors.divider;

  static const white = Color(0xFFFFFFFF);
  static Color get black => isDark ? DarkModeColors.textPrimary : Colors.black;
  static const starcolor = Color(0xFFF4A623);
  static Color get red => isDark ? const Color(0xFFF87171) : Colors.red;
  static Color get green => isDark ? const Color(0xFF4ADE80) : Colors.green;
}

class DarkMode {
  static const primaryColor = Color(0xFF38BDF8);
}

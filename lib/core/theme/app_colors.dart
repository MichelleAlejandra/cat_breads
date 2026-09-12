import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  static const primary = Color(0xFFC25E2E);

  static const splashBackground = Color(0xFFFFF3E0);
  static const splashTitle = Color(0xFF6D4C41);

  static const splashRingSlowBorder = Color(0xFFF3CCA3);
  static const splashRingSlowFill = Color(0xFFFFF5EA);
  static const splashRingFastBorder = Color(0xFFEAB27B);
  static const splashRingFastFill = Color(0xFFFDE9D2);

  static const cardBorder = Color(0xFFE7E5E4);
  static const pageBackground = Color(0xFFF5F5F4);
  static const surface = Colors.white;

  static const textMuted = Color(0xFF9E9E9E);
  static const textPrimary = Colors.black;
  static const textSecondary = Colors.black87;

  // Cat stat categories (life span, weight, height, origin), shared between
  // the list card and the detail grid so both stay in sync.
  static const statLongevity = Colors.red;
  static const statWeight = Colors.orange;
  static const statHeight = Colors.blue;
  static const statOrigin = Colors.green;
}

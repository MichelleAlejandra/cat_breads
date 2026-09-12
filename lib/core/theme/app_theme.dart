import 'package:cat_breeds_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData get light {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
    );
    final TextTheme textTheme = GoogleFonts.plusJakartaSansTextTheme(
      ThemeData(colorScheme: colorScheme).textTheme,
    );

    final ThemeData base = ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.pageBackground,
      appBarTheme: AppBarTheme(
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          fontSize: 22,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        suffixIconColor: AppColors.textMuted,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.cardBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          iconSize: 24,
        ),
      ),
    );

    return base.copyWith(
      textTheme: textTheme.copyWith(
        headlineLarge: textTheme.headlineLarge?.copyWith(
          fontSize: 36,
          fontWeight: FontWeight.w700,
        ),
        headlineSmall: textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
        titleSmall: textTheme.titleSmall?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          height: 1.0,
        ),
        labelSmall: textTheme.labelSmall?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

/// PromptGuard color system.
/// Dark, security-console aesthetic: near-black background, indigo/purple
/// brand accent, and a strict semantic palette for verdicts/severity so the
/// eye can triage at a glance (red = blocked/critical, green = safe/passed,
/// amber = masked/warning).
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0B0D14);
  static const Color surface = Color(0xFF141726);
  static const Color surfaceElevated = Color(0xFF1B1F33);
  static const Color border = Color(0xFF272C45);

  static const Color brandPrimary = Color(0xFF7C6CFF);
  static const Color brandSecondary = Color(0xFF4DD0E1);

  static const Color textPrimary = Color(0xFFF2F3F8);
  static const Color textSecondary = Color(0xFF9AA0B4);
  static const Color textMuted = Color(0xFF6B7086);

  // Semantic verdict / severity colors
  static const Color danger = Color(0xFFFF5470);
  static const Color dangerBg = Color(0x26FF5470);
  static const Color success = Color(0xFF31D0AA);
  static const Color successBg = Color(0x2631D0AA);
  static const Color warning = Color(0xFFFFB454);
  static const Color warningBg = Color(0x26FFB454);
  static const Color info = Color(0xFF4DA3FF);
  static const Color infoBg = Color(0x264DA3FF);
}

class AppTheme {
  AppTheme._();

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.brandPrimary,
        secondary: AppColors.brandSecondary,
        surface: AppColors.surface,
        error: AppColors.danger,
      ),
      textTheme: base.textTheme.apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.brandPrimary.withValues(alpha: 0.18),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? AppColors.brandPrimary : AppColors.textMuted,
          );
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: AppColors.brandPrimary,
        inactiveTrackColor: AppColors.border,
        thumbColor: AppColors.brandPrimary,
        overlayColor: AppColors.brandPrimary.withValues(alpha: 0.15),
        valueIndicatorColor: AppColors.brandPrimary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceElevated,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brandPrimary),
        ),
        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
      ),
    );
  }
}

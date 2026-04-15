import 'package:flutter/material.dart';

import 'app_tokens.dart';

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: AppColors.primaryDeep,
            brightness: Brightness.light,
          ).copyWith(
            primary: AppColors.primaryDeep,
            secondary: AppColors.primary,
            surface: Colors.white,
            error: AppColors.error,
          ),
    );

    final textTheme = _buildTextTheme(base.textTheme);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.pageBottom,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.medium),
        ),
        margin: EdgeInsets.zero,
      ),
      chipTheme: base.chipTheme.copyWith(
        side: BorderSide.none,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.small,
          vertical: 6,
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.strongText),
      dividerColor: Colors.white.withValues(alpha: 0.35),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base) {
    TextStyle style(TextStyle? source) {
      return (source ?? const TextStyle()).copyWith(
        color: AppColors.strongText,
        fontFamilyFallback: AppTypography.fallbackFonts,
      );
    }

    return TextTheme(
      displayLarge: style(
        base.displayLarge,
      ).copyWith(fontSize: 54, fontWeight: FontWeight.w800, height: 1.02),
      displayMedium: style(
        base.displayMedium,
      ).copyWith(fontSize: 42, fontWeight: FontWeight.w800, height: 1.05),
      displaySmall: style(
        base.displaySmall,
      ).copyWith(fontSize: 34, fontWeight: FontWeight.w800, height: 1.1),
      headlineLarge: style(
        base.headlineLarge,
      ).copyWith(fontSize: 30, fontWeight: FontWeight.w700),
      headlineMedium: style(
        base.headlineMedium,
      ).copyWith(fontSize: 26, fontWeight: FontWeight.w700),
      headlineSmall: style(
        base.headlineSmall,
      ).copyWith(fontSize: 22, fontWeight: FontWeight.w700),
      titleLarge: style(
        base.titleLarge,
      ).copyWith(fontSize: 20, fontWeight: FontWeight.w700),
      titleMedium: style(
        base.titleMedium,
      ).copyWith(fontSize: 16, fontWeight: FontWeight.w700),
      titleSmall: style(
        base.titleSmall,
      ).copyWith(fontSize: 14, fontWeight: FontWeight.w700),
      bodyLarge: style(base.bodyLarge).copyWith(fontSize: 15, height: 1.45),
      bodyMedium: style(base.bodyMedium).copyWith(fontSize: 14, height: 1.45),
      bodySmall: style(
        base.bodySmall,
      ).copyWith(fontSize: 12, height: 1.4, color: AppColors.mutedText),
      labelLarge: style(
        base.labelLarge,
      ).copyWith(fontSize: 14, fontWeight: FontWeight.w700),
      labelMedium: style(
        base.labelMedium,
      ).copyWith(fontSize: 12, fontWeight: FontWeight.w700),
      labelSmall: style(
        base.labelSmall,
      ).copyWith(fontSize: 11, fontWeight: FontWeight.w700),
    );
  }
}

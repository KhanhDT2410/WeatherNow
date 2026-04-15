import 'package:flutter/material.dart';

abstract final class AppBreakpoints {
  static const double mobile = 720;
  static const double desktop = 1100;
  static const double maxContentWidth = 1280;
}

abstract final class AppSpacing {
  static const double xSmall = 8;
  static const double small = 12;
  static const double medium = 16;
  static const double large = 24;
  static const double xLarge = 32;
  static const double xxLarge = 40;
}

abstract final class AppRadius {
  static const double small = 18;
  static const double medium = 24;
  static const double large = 32;
  static const double pill = 999;
}

abstract final class AppColors {
  static const Color pageTop = Color(0xFF0B1226);
  static const Color pageBottom = Color(0xFF172C56);
  static const Color pageGlow = Color(0xFF46C2FF);
  static const Color pageGlowSecondary = Color(0xFFFFB86B);

  static const Color surface = Color(0xFFF7FAFF);
  static const Color surfaceAlt = Color(0xFFEFF5FF);
  static const Color glassStroke = Color(0x99FFFFFF);
  static const Color strongText = Color(0xFF10203D);
  static const Color mutedText = Color(0xFF61708D);
  static const Color primary = Color(0xFF5AC8FA);
  static const Color primaryDeep = Color(0xFF2176FF);
  static const Color accentWarm = Color(0xFFFFB74A);
  static const Color success = Color(0xFF27C281);
  static const Color error = Color(0xFFFF6B6B);
}

abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x140D1B35), blurRadius: 36, offset: Offset(0, 18)),
    BoxShadow(color: Color(0x0F0D1B35), blurRadius: 12, offset: Offset(0, 6)),
  ];

  static const List<BoxShadow> cardHover = [
    BoxShadow(color: Color(0x220D1B35), blurRadius: 44, offset: Offset(0, 24)),
    BoxShadow(color: Color(0x120D1B35), blurRadius: 16, offset: Offset(0, 8)),
  ];
}

abstract final class AppTypography {
  static const List<String> fallbackFonts = [
    'SF Pro Display',
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];
}

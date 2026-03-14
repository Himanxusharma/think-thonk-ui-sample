import 'package:flutter/material.dart';

/// Color Palette - Matching the OKLCH color space from web
class AppColors {
  AppColors._();

  // Light Mode Colors (converted from OKLCH to Hex)
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightForeground = Color(0xFF1A1A2E);
  static const Color lightCard = Color(0xFFF5F5F5);
  static const Color lightCardForeground = Color(0xFF1A1A2E);
  static const Color lightPrimary = Color(0xFF2D2D3A);
  static const Color lightPrimaryForeground = Color(0xFFF5F5F5);
  static const Color lightSecondary = Color(0xFF6B6B7B);
  static const Color lightSecondaryForeground = Color(0xFF1A1A2E);
  static const Color lightMuted = Color(0xFFDDDDE0);
  static const Color lightMutedForeground = Color(0xFF5A5A6E);
  static const Color lightAccent = Color(0xFF2D2D3A);
  static const Color lightAccentForeground = Color(0xFFF5F5F5);
  static const Color lightDestructive = Color(0xFFDC4545);
  static const Color lightDestructiveForeground = Color(0xFFF5F5F5);
  static const Color lightBorder = Color(0xFFE5E5E8);
  static const Color lightInput = Color(0xFFE5E5E8);
  static const Color lightRing = Color(0xFF5A5A6E);

  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF0A0A0A);
  static const Color darkForeground = Color(0xFFFAFAFA);
  static const Color darkCard = Color(0xFF0A0A0A);
  static const Color darkCardForeground = Color(0xFFFAFAFA);
  static const Color darkPrimary = Color(0xFFFAFAFA);
  static const Color darkPrimaryForeground = Color(0xFF1A1A1A);
  static const Color darkSecondary = Color(0xFF2A2A2A);
  static const Color darkSecondaryForeground = Color(0xFFFAFAFA);
  static const Color darkMuted = Color(0xFF2A2A2A);
  static const Color darkMutedForeground = Color(0xFFA0A0A0);
  static const Color darkAccent = Color(0xFF2A2A2A);
  static const Color darkAccentForeground = Color(0xFFFAFAFA);
  static const Color darkDestructive = Color(0xFF7F1D1D);
  static const Color darkDestructiveForeground = Color(0xFFDC4545);
  static const Color darkBorder = Color(0xFF2A2A2A);
  static const Color darkInput = Color(0xFF2A2A2A);
  static const Color darkRing = Color(0xFF5A5A5A);

  // Special Colors
  static const Color likeRed = Color(0xFFEF4444);
  static const Color streakOrange = Color(0xFFF97316);
  static const Color successGreen = Color(0xFF22C55E);
  static const Color warningYellow = Color(0xFFEAB308);
  static const Color infoBlue = Color(0xFF3B82F6);
}

/// Typography constants
class AppTypography {
  AppTypography._();

  static const String fontFamily = 'Geist';
  static const String fontFamilyMono = 'GeistMono';

  // Font Sizes (in logical pixels)
  static const double fontSizeXs = 12.0;
  static const double fontSizeSm = 14.0;
  static const double fontSizeBase = 16.0;
  static const double fontSizeLg = 18.0;
  static const double fontSizeXl = 20.0;
  static const double fontSize2xl = 24.0;
  static const double fontSize3xl = 30.0;
  static const double fontSize4xl = 36.0;
  static const double fontSize5xl = 48.0;
  static const double fontSize6xl = 60.0;

  // Font Weights
  static const FontWeight fontWeightRegular = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;

  // Line Heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.6;
}

/// Spacing constants (in logical pixels)
class AppSpacing {
  AppSpacing._();

  static const double sp0 = 0.0;
  static const double sp1 = 4.0;
  static const double sp2 = 8.0;
  static const double sp3 = 12.0;
  static const double sp4 = 16.0;
  static const double sp5 = 20.0;
  static const double sp6 = 24.0;
  static const double sp8 = 32.0;
  static const double sp10 = 40.0;
  static const double sp12 = 48.0;
  static const double sp16 = 64.0;
  static const double sp20 = 80.0;
  static const double sp24 = 96.0;
}

/// Border Radius constants
class AppRadius {
  AppRadius._();

  static const double xs = 2.0;
  static const double sm = 4.0;
  static const double md = 6.0;
  static const double lg = 8.0;
  static const double xl = 12.0;
  static const double xxl = 16.0;
  static const double full = 9999.0;
}

/// Responsive Breakpoints
class AppBreakpoints {
  AppBreakpoints._();

  static const double mobile = 320.0;
  static const double sm = 640.0;
  static const double md = 768.0;
  static const double lg = 1024.0;
  static const double xl = 1280.0;
}

/// Animation/Transition Durations
class AppAnimations {
  AppAnimations._();

  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
}

/// UI Constants
class AppUI {
  AppUI._();

  static const double navbarHeight = 64.0;
  static const double bottomNavHeight = 64.0;
  static const double modalMaxWidth = 672.0;
  static const double cardMaxWidth = 476.0;
  static const int defaultStreak = 7;
  static const int autoScrollDebounce = 500;
  static const double autoScrollVelocityThreshold = 8.0;
}

/// Z-Index Scale
class AppZIndex {
  AppZIndex._();

  static const int hide = -1;
  static const int auto = 0;
  static const int base = 0;
  static const int navbar = 10;
  static const int dropdown = 50;
  static const int modal = 100;
  static const int topmost = 1000;
}

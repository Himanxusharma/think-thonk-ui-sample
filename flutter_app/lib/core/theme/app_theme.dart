import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: const ColorScheme.light(
      background: AppColors.lightBackground,
      surface: AppColors.lightCard,
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightPrimaryForeground,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightSecondaryForeground,
      error: AppColors.lightDestructive,
      onError: AppColors.lightDestructiveForeground,
      onBackground: AppColors.lightForeground,
      onSurface: AppColors.lightCardForeground,
      outline: AppColors.lightBorder,
    ),
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,
    dividerColor: AppColors.lightBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.lightBackground,
      foregroundColor: AppColors.lightForeground,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),
    textTheme: _buildTextTheme(AppColors.lightForeground),
    iconTheme: const IconThemeData(
      color: AppColors.lightMutedForeground,
      size: 24,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.lightPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp4,
        vertical: AppSpacing.sp3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightPrimary,
        foregroundColor: AppColors.lightPrimaryForeground,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp6,
          vertical: AppSpacing.sp3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        textStyle: const TextStyle(
          fontWeight: AppTypography.fontWeightMedium,
          fontSize: AppTypography.fontSizeSm,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.lightPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp4,
          vertical: AppSpacing.sp2,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.lightCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.lightBorder),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    fontFamily: GoogleFonts.inter().fontFamily,
    colorScheme: const ColorScheme.dark(
      background: AppColors.darkBackground,
      surface: AppColors.darkCard,
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkPrimaryForeground,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.darkSecondaryForeground,
      error: AppColors.darkDestructive,
      onError: AppColors.darkDestructiveForeground,
      onBackground: AppColors.darkForeground,
      onSurface: AppColors.darkCardForeground,
      outline: AppColors.darkBorder,
    ),
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,
    dividerColor: AppColors.darkBorder,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.darkBackground,
      foregroundColor: AppColors.darkForeground,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
    textTheme: _buildTextTheme(AppColors.darkForeground),
    iconTheme: const IconThemeData(
      color: AppColors.darkMutedForeground,
      size: 24,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.darkBackground,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        borderSide: const BorderSide(color: AppColors.darkPrimary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sp4,
        vertical: AppSpacing.sp3,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: AppColors.darkPrimaryForeground,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp6,
          vertical: AppSpacing.sp3,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        textStyle: const TextStyle(
          fontWeight: AppTypography.fontWeightMedium,
          fontSize: AppTypography.fontSizeSm,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.darkPrimary,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp4,
          vertical: AppSpacing.sp2,
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: AppColors.darkCard,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: const BorderSide(color: AppColors.darkBorder),
      ),
    ),
  );

  static TextTheme _buildTextTheme(Color foreground) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: AppTypography.fontSize6xl,
        fontWeight: AppTypography.fontWeightBold,
        height: AppTypography.lineHeightTight,
        color: foreground,
      ),
      displayMedium: TextStyle(
        fontSize: AppTypography.fontSize5xl,
        fontWeight: AppTypography.fontWeightBold,
        height: AppTypography.lineHeightTight,
        color: foreground,
      ),
      displaySmall: TextStyle(
        fontSize: AppTypography.fontSize4xl,
        fontWeight: AppTypography.fontWeightBold,
        height: AppTypography.lineHeightTight,
        color: foreground,
      ),
      headlineLarge: TextStyle(
        fontSize: AppTypography.fontSize3xl,
        fontWeight: AppTypography.fontWeightBold,
        height: AppTypography.lineHeightTight,
        color: foreground,
      ),
      headlineMedium: TextStyle(
        fontSize: AppTypography.fontSize2xl,
        fontWeight: AppTypography.fontWeightBold,
        height: AppTypography.lineHeightNormal,
        color: foreground,
      ),
      headlineSmall: TextStyle(
        fontSize: AppTypography.fontSizeXl,
        fontWeight: AppTypography.fontWeightSemibold,
        height: AppTypography.lineHeightNormal,
        color: foreground,
      ),
      titleLarge: TextStyle(
        fontSize: AppTypography.fontSizeLg,
        fontWeight: AppTypography.fontWeightSemibold,
        height: AppTypography.lineHeightNormal,
        color: foreground,
      ),
      titleMedium: TextStyle(
        fontSize: AppTypography.fontSizeBase,
        fontWeight: AppTypography.fontWeightMedium,
        height: AppTypography.lineHeightNormal,
        color: foreground,
      ),
      titleSmall: TextStyle(
        fontSize: AppTypography.fontSizeSm,
        fontWeight: AppTypography.fontWeightMedium,
        height: AppTypography.lineHeightNormal,
        color: foreground,
      ),
      bodyLarge: TextStyle(
        fontSize: AppTypography.fontSizeLg,
        fontWeight: AppTypography.fontWeightRegular,
        height: AppTypography.lineHeightRelaxed,
        color: foreground.withOpacity(0.8),
      ),
      bodyMedium: TextStyle(
        fontSize: AppTypography.fontSizeBase,
        fontWeight: AppTypography.fontWeightRegular,
        height: AppTypography.lineHeightRelaxed,
        color: foreground.withOpacity(0.8),
      ),
      bodySmall: TextStyle(
        fontSize: AppTypography.fontSizeSm,
        fontWeight: AppTypography.fontWeightRegular,
        height: AppTypography.lineHeightRelaxed,
        color: foreground.withOpacity(0.75),
      ),
      labelLarge: TextStyle(
        fontSize: AppTypography.fontSizeSm,
        fontWeight: AppTypography.fontWeightMedium,
        height: AppTypography.lineHeightNormal,
        color: foreground,
      ),
      labelMedium: TextStyle(
        fontSize: AppTypography.fontSizeXs,
        fontWeight: AppTypography.fontWeightMedium,
        height: AppTypography.lineHeightNormal,
        color: foreground,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: AppTypography.fontSizeXs,
        fontWeight: AppTypography.fontWeightRegular,
        height: AppTypography.lineHeightNormal,
        color: foreground.withOpacity(0.6),
      ),
    );
  }
}

/// Extension to get custom colors based on theme
extension ThemeExtensions on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  Color get mutedForeground =>
      isDarkMode ? AppColors.darkMutedForeground : AppColors.lightMutedForeground;

  Color get borderColor =>
      isDarkMode ? AppColors.darkBorder : AppColors.lightBorder;

  Color get cardBackground =>
      isDarkMode ? AppColors.darkCard : AppColors.lightCard;
}

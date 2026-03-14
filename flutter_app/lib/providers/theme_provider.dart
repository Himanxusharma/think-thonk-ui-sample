import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/content_model.dart';

/// Theme Provider - Manages app theme state
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});

class ThemeState {
  final AppThemeMode mode;
  final ThemeMode effectiveTheme;

  const ThemeState({
    required this.mode,
    required this.effectiveTheme,
  });

  ThemeState copyWith({
    AppThemeMode? mode,
    ThemeMode? effectiveTheme,
  }) {
    return ThemeState(
      mode: mode ?? this.mode,
      effectiveTheme: effectiveTheme ?? this.effectiveTheme,
    );
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  static const String _themeKey = 'theme_mode';

  ThemeNotifier()
      : super(const ThemeState(
          mode: AppThemeMode.light,
          effectiveTheme: ThemeMode.light,
        )) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeName = prefs.getString(_themeKey) ?? 'light';
    final mode = AppThemeMode.values.firstWhere(
      (e) => e.name == themeName,
      orElse: () => AppThemeMode.light,
    );
    await setTheme(mode, save: false);
  }

  Future<void> setTheme(AppThemeMode mode, {bool save = true}) async {
    ThemeMode effectiveTheme;
    
    switch (mode) {
      case AppThemeMode.light:
        effectiveTheme = ThemeMode.light;
        break;
      case AppThemeMode.dark:
        effectiveTheme = ThemeMode.dark;
        break;
      case AppThemeMode.system:
        effectiveTheme = ThemeMode.system;
        break;
    }

    state = state.copyWith(
      mode: mode,
      effectiveTheme: effectiveTheme,
    );

    if (save) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.name);
    }
  }

  void toggleTheme() {
    if (state.mode == AppThemeMode.light) {
      setTheme(AppThemeMode.dark);
    } else {
      setTheme(AppThemeMode.light);
    }
  }
}

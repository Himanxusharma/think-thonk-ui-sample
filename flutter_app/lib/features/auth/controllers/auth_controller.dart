import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';
import '../repositories/auth_repository.dart';

// ─── Theme controller (lives here to keep settings simple) ───────────────────

enum AppThemeMode { light, dark, system }

class ThemeState {
  final AppThemeMode mode;
  final ThemeMode effectiveTheme;

  const ThemeState({
    required this.mode,
    required this.effectiveTheme,
  });

  ThemeState copyWith({AppThemeMode? mode, ThemeMode? effectiveTheme}) {
    return ThemeState(
      mode: mode ?? this.mode,
      effectiveTheme: effectiveTheme ?? this.effectiveTheme,
    );
  }
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, ThemeState>((ref) {
  return ThemeController();
});

class ThemeController extends StateNotifier<ThemeState> {
  static const String _key = 'theme_mode';

  ThemeController()
      : super(const ThemeState(
          mode: AppThemeMode.light,
          effectiveTheme: ThemeMode.light,
        )) {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key) ?? 'light';
    final mode = AppThemeMode.values.firstWhere(
      (e) => e.name == name,
      orElse: () => AppThemeMode.light,
    );
    await setTheme(mode, persist: false);
  }

  Future<void> setTheme(AppThemeMode mode, {bool persist = true}) async {
    final effective = switch (mode) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };
    state = state.copyWith(mode: mode, effectiveTheme: effective);
    if (persist) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, mode.name);
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

// ─── Auth controller ──────────────────────────────────────────────────────────

class AuthState {
  final AppUser? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    AppUser? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    bool clearError = false,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(AuthRepository.instance);
});

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthController(this._repository) : super(const AuthState()) {
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    state = state.copyWith(isLoading: true);
    final session = await _repository.getSession();
    if (session != null) {
      state = state.copyWith(
        user: session.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = state.copyWith(isLoading: false, isAuthenticated: false);
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final response = await _repository.login(email, password);
    if (response.success && response.session != null) {
      state = state.copyWith(
        user: response.session!.user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    }
    state = state.copyWith(
      isLoading: false,
      error: response.error ?? 'Login failed',
    );
    return false;
  }

  Future<bool> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final response = await _repository.register(email, password, name);
    if (response.success) {
      state = state.copyWith(isLoading: false);
      return true;
    }
    state = state.copyWith(
      isLoading: false,
      error: response.error ?? 'Registration failed',
    );
    return false;
  }

  Future<void> logout() async {
    await _repository.logout();
    state = const AuthState();
  }

  Map<String, TestCredentials> get testCredentials =>
      _repository.getTestCredentials();

  bool get isAdmin => state.user?.isAdmin ?? false;
}

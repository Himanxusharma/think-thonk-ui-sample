import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

/// Auth state
class AuthState {
  final AuthUser? user;
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
    AuthUser? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState()) {
    _checkSession();
  }

  Future<void> _checkSession() async {
    state = state.copyWith(isLoading: true);
    
    final session = await AuthService.getSession();
    if (session != null) {
      state = state.copyWith(
        user: session.user,
        isAuthenticated: true,
        isLoading: false,
      );
    } else {
      state = state.copyWith(
        isLoading: false,
        isAuthenticated: false,
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await AuthService.login(email, password);

    if (response.success && response.session != null) {
      state = state.copyWith(
        user: response.session!.user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error ?? 'Login failed',
      );
      return false;
    }
  }

  Future<bool> register(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, error: null);

    final response = await AuthService.register(email, password, name);

    if (response.success) {
      state = state.copyWith(isLoading: false);
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        error: response.error ?? 'Registration failed',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await AuthService.logout();
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  bool get isAdmin => state.user?.isAdmin ?? false;
  bool get isModerator => state.user?.isModerator ?? false;
}

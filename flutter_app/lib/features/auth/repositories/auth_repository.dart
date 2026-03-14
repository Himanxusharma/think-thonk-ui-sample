import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_user.dart';

/// Auth repository – handles session persistence and credential checks.
/// Mirrors the Next.js AuthService with hardcoded test users.
class AuthRepository {
  AuthRepository._();
  static final AuthRepository instance = AuthRepository._();

  static const String _sessionKey = 'auth_session';

  static final List<_TestUser> _testUsers = [
    _TestUser(
      id: 'admin_001',
      email: 'admin@thinkthonk.com',
      password: 'Admin123!@#',
      name: 'Admin User',
      role: 'admin',
      createdAt: DateTime(2024, 1, 1),
    ),
    _TestUser(
      id: 'user_001',
      email: 'demo@thinkthonk.com',
      password: 'Demo123!@#',
      name: 'Demo User',
      role: 'user',
      createdAt: DateTime(2024, 1, 15),
    ),
  ];

  Future<AuthResponse> login(String email, String password) async {
    final user = _testUsers.where((u) => u.email == email).firstOrNull;
    if (user == null) {
      return const AuthResponse(success: false, error: 'User not found');
    }
    if (user.password != password) {
      return const AuthResponse(success: false, error: 'Invalid password');
    }

    final token = 'dev_${user.id}_${DateTime.now().millisecondsSinceEpoch}';
    final session = AuthSession(
      user: AppUser(
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        createdAt: user.createdAt,
      ),
      token: token,
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    await _persist(session);
    return AuthResponse(success: true, message: 'Login successful', session: session);
  }

  Future<AuthResponse> register(
      String email, String password, String name) async {
    final exists = _testUsers.any((u) => u.email == email);
    if (exists) {
      return const AuthResponse(
          success: false, error: 'Email already registered');
    }
    return const AuthResponse(
        success: true, message: 'Account created. Please log in.');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
  }

  Future<AuthSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_sessionKey);
    if (json == null) return null;
    try {
      final session =
          AuthSession.fromJson(jsonDecode(json) as Map<String, dynamic>);
      if (session.isExpired) {
        await logout();
        return null;
      }
      return session;
    } catch (_) {
      return null;
    }
  }

  Future<void> _persist(AuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
  }

  Map<String, TestCredentials> getTestCredentials() => {
        'admin': const TestCredentials(
          email: 'admin@thinkthonk.com',
          password: 'Admin123!@#',
          name: 'Admin User',
        ),
        'user': const TestCredentials(
          email: 'demo@thinkthonk.com',
          password: 'Demo123!@#',
          name: 'Demo User',
        ),
      };
}

class _TestUser {
  final String id;
  final String email;
  final String password;
  final String name;
  final String role;
  final DateTime createdAt;

  const _TestUser({
    required this.id,
    required this.email,
    required this.password,
    required this.name,
    required this.role,
    required this.createdAt,
  });
}

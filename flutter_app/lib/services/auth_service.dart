import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth_model.dart';

/// Authentication Service
/// Manages user login, registration, and session handling
class AuthService {
  static const String _sessionKey = 'auth_session';
  static const String _tokenKey = 'auth_token';

  /// Hardcoded test users (same as web version)
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

  /// Login user with email and password
  static Future<AuthResponse> login(String email, String password) async {
    // Find user in test data
    final user = _testUsers.where((u) => u.email == email).firstOrNull;

    if (user == null) {
      return const AuthResponse(
        success: false,
        error: 'User not found',
      );
    }

    if (user.password != password) {
      return const AuthResponse(
        success: false,
        error: 'Invalid password',
      );
    }

    // Generate token
    final token = _generateToken(user.id);
    final expiresAt = DateTime.now().add(const Duration(hours: 24));

    final session = AuthSession(
      user: AuthUser(
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        createdAt: user.createdAt,
      ),
      token: token,
      expiresAt: expiresAt,
    );

    // Store session
    await _setSession(session);

    return AuthResponse(
      success: true,
      message: 'Login successful',
      session: session,
    );
  }

  /// Register new user
  static Future<AuthResponse> register(
    String email,
    String password,
    String name,
  ) async {
    // Check if user already exists
    final existingUser = _testUsers.where((u) => u.email == email).firstOrNull;
    if (existingUser != null) {
      return const AuthResponse(
        success: false,
        error: 'Email already registered',
      );
    }

    return const AuthResponse(
      success: true,
      message: 'Account created. Please log in.',
    );
  }

  /// Logout current user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_sessionKey);
    await prefs.remove(_tokenKey);
  }

  /// Get current session
  static Future<AuthSession?> getSession() async {
    final prefs = await SharedPreferences.getInstance();
    final sessionJson = prefs.getString(_sessionKey);

    if (sessionJson == null) return null;

    try {
      final session = AuthSession.fromJson(
        jsonDecode(sessionJson) as Map<String, dynamic>,
      );

      // Check if token is expired
      if (session.isExpired) {
        await logout();
        return null;
      }

      return session;
    } catch (e) {
      return null;
    }
  }

  /// Check if user is authenticated
  static Future<bool> isAuthenticated() async {
    final session = await getSession();
    return session != null;
  }

  /// Check if current user is admin
  static Future<bool> isAdmin() async {
    final session = await getSession();
    return session?.user.isAdmin ?? false;
  }

  /// Check if current user is moderator
  static Future<bool> isModerator() async {
    final session = await getSession();
    return session?.user.isModerator ?? false;
  }

  /// Get current user
  static Future<AuthUser?> getCurrentUser() async {
    final session = await getSession();
    return session?.user;
  }

  /// Get current user ID
  static Future<String?> getCurrentUserId() async {
    final user = await getCurrentUser();
    return user?.id;
  }

  /// Store session
  static Future<void> _setSession(AuthSession session) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionKey, jsonEncode(session.toJson()));
    await prefs.setString(_tokenKey, session.token);
  }

  /// Generate a simple token (development only)
  static String _generateToken(String userId) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = DateTime.now().microsecond.toString();
    return 'dev_${userId}_${timestamp}_$random';
  }

  /// Test user credentials (for UI display and testing)
  static Map<String, TestCredentials> getTestCredentials() {
    return {
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
}

/// Internal test user class
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

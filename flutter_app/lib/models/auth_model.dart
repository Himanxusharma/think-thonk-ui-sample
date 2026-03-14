/// Authentication Models

class AuthUser {
  final String id;
  final String email;
  final String name;
  final String role; // 'admin', 'user', 'moderator'
  final DateTime createdAt;

  const AuthUser({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
  });

  bool get isAdmin => role == 'admin';
  bool get isModerator => role == 'moderator';

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}

class AuthSession {
  final AuthUser user;
  final String token;
  final DateTime expiresAt;

  const AuthSession({
    required this.user,
    required this.token,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
      'expiresAt': expiresAt.toIso8601String(),
    };
  }

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      user: AuthUser.fromJson(json['user'] as Map<String, dynamic>),
      token: json['token'] as String,
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }
}

class AuthResponse {
  final bool success;
  final String? message;
  final AuthSession? session;
  final String? error;

  const AuthResponse({
    required this.success,
    this.message,
    this.session,
    this.error,
  });
}

class TestCredentials {
  final String email;
  final String password;
  final String name;

  const TestCredentials({
    required this.email,
    required this.password,
    required this.name,
  });
}

/**
 * Authentication Service
 * Manages user login, registration, and session handling
 * Currently uses hardcoded test users for development
 * 
 * MIGRATION: Replace with real database queries when DB is set up
 */

export interface AuthUser {
  id: string
  email: string
  name: string
  role: 'admin' | 'user' | 'moderator'
  createdAt: Date
}

export interface AuthSession {
  user: AuthUser
  token: string
  expiresAt: Date
}

export interface AuthResponse {
  success: boolean
  message?: string
  session?: AuthSession
  error?: string
}

/**
 * HARDCODED TEST USERS
 * Replace this with database query when DB is set up:
 * const user = await db.users.findOne({ email })
 */
const TEST_USERS = [
  {
    id: 'admin_001',
    email: 'admin@thinkthonk.com',
    password: 'Admin123!@#', // In production: bcrypt hash
    name: 'Admin User',
    role: 'admin' as const,
    createdAt: new Date('2024-01-01'),
  },
  {
    id: 'user_001',
    email: 'demo@thinkthonk.com',
    password: 'Demo123!@#', // In production: bcrypt hash
    name: 'Demo User',
    role: 'user' as const,
    createdAt: new Date('2024-01-15'),
  },
]

class AuthService {
  /**
   * Login user with email and password
   * TODO: Replace with actual database query and bcrypt comparison
   */
  static login(email: string, password: string): AuthResponse {
    // Find user in test data
    const user = TEST_USERS.find((u) => u.email === email)

    if (!user) {
      return {
        success: false,
        error: 'User not found',
      }
    }

    // In production: use bcrypt.compare(password, user.passwordHash)
    if (user.password !== password) {
      return {
        success: false,
        error: 'Invalid password',
      }
    }

    // Generate token (in production: use JWT)
    const token = this.generateToken(user.id)
    const expiresAt = new Date(Date.now() + 24 * 60 * 60 * 1000) // 24 hours

    const session: AuthSession = {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        role: user.role,
        createdAt: user.createdAt,
      },
      token,
      expiresAt,
    }

    // Store session in localStorage (development only)
    this.setSession(session)

    return {
      success: true,
      message: 'Login successful',
      session,
    }
  }

  /**
   * Register new user
   * TODO: Replace with database insertion and bcrypt hashing
   */
  static register(
    email: string,
    password: string,
    name: string
  ): AuthResponse {
    // Check if user already exists
    const existingUser = TEST_USERS.find((u) => u.email === email)
    if (existingUser) {
      return {
        success: false,
        error: 'Email already registered',
      }
    }

    // In production:
    // 1. Hash password with bcrypt
    // 2. Insert into database
    // 3. Send verification email
    // 4. Return pending activation status

    return {
      success: true,
      message: 'Account created. Please log in.',
    }
  }

  /**
   * Logout current user
   */
  static logout(): void {
    if (typeof window !== 'undefined') {
      localStorage.removeItem('auth_session')
      localStorage.removeItem('auth_token')
    }
  }

  /**
   * Get current session from localStorage
   */
  static getSession(): AuthSession | null {
    if (typeof window === 'undefined') return null

    const sessionJson = localStorage.getItem('auth_session')
    if (!sessionJson) return null

    try {
      const session = JSON.parse(sessionJson)
      // Check if token is expired
      if (new Date(session.expiresAt) < new Date()) {
        this.logout()
        return null
      }
      return session
    } catch {
      return null
    }
  }

  /**
   * Check if user is authenticated
   */
  static isAuthenticated(): boolean {
    return this.getSession() !== null
  }

  /**
   * Check if current user is admin
   */
  static isAdmin(): boolean {
    const session = this.getSession()
    return session?.user.role === 'admin'
  }

  /**
   * Check if current user is moderator
   */
  static isModerator(): boolean {
    const session = this.getSession()
    return session?.user.role === 'moderator'
  }

  /**
   * Get current user
   */
  static getCurrentUser(): AuthUser | null {
    const session = this.getSession()
    return session?.user ?? null
  }

  /**
   * Get current user ID
   */
  static getCurrentUserId(): string | null {
    return this.getCurrentUser()?.id ?? null
  }

  /**
   * Store session in localStorage
   */
  private static setSession(session: AuthSession): void {
    if (typeof window === 'undefined') return
    localStorage.setItem('auth_session', JSON.stringify(session))
    localStorage.setItem('auth_token', session.token)
  }

  /**
   * Generate a simple token (development only)
   * In production: use JWT with RS256 signing
   */
  private static generateToken(userId: string): string {
    const timestamp = Date.now()
    const random = Math.random().toString(36).substring(2, 15)
    return `dev_${userId}_${timestamp}_${random}`
  }

  /**
   * Test user credentials (for UI display and testing)
   */
  static getTestCredentials() {
    return {
      admin: {
        email: 'admin@thinkthonk.com',
        password: 'Admin123!@#',
        name: 'Admin User',
      },
      user: {
        email: 'demo@thinkthonk.com',
        password: 'Demo123!@#',
        name: 'Demo User',
      },
    }
  }
}

export default AuthService

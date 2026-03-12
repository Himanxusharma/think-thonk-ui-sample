/**
 * Role-Based Access Control Models
 * 
 * Defines user roles and admin-related interfaces for role-based access control.
 * This is designed to be easily portable to Flutter and other platforms.
 */

export enum UserRole {
  USER = 'user',
  ADMIN = 'admin',
  MODERATOR = 'moderator',
}

export interface UserProfile {
  id: string
  name: string
  email: string
  bio?: string
  location?: string
  joinDate: string
  avatar?: string
}

export interface AdminUser extends UserProfile {
  role: UserRole
  createdAt: string
  lastActiveAt?: string
}

export interface RolePermission {
  role: UserRole
  canCreateContent: boolean
  canPublishContent: boolean
  canDeleteContent: boolean
  canModerateComments: boolean
  canAccessAdminDashboard: boolean
}

/**
 * Role-to-Permissions mapping
 * Define what each role can do in the application
 */
export const ROLE_PERMISSIONS: Record<UserRole, RolePermission> = {
  [UserRole.USER]: {
    role: UserRole.USER,
    canCreateContent: false,
    canPublishContent: false,
    canDeleteContent: false,
    canModerateComments: false,
    canAccessAdminDashboard: false,
  },
  [UserRole.ADMIN]: {
    role: UserRole.ADMIN,
    canCreateContent: true,
    canPublishContent: true,
    canDeleteContent: true,
    canModerateComments: true,
    canAccessAdminDashboard: true,
  },
  [UserRole.MODERATOR]: {
    role: UserRole.MODERATOR,
    canCreateContent: true,
    canPublishContent: false,
    canDeleteContent: false,
    canModerateComments: true,
    canAccessAdminDashboard: true,
  },
}

/**
 * Check if a user has permission for an action
 * @param role - The user's role
 * @param permission - The permission to check
 * @returns true if user has permission, false otherwise
 */
export function hasPermission(
  role: UserRole,
  permission: keyof RolePermission,
): boolean {
  const permissions = ROLE_PERMISSIONS[role]
  return (permissions[permission] as boolean) ?? false
}

/**
 * Check if user can access admin dashboard
 * @param role - The user's role
 * @returns true if user can access admin dashboard
 */
export function canAccessAdmin(role: UserRole): boolean {
  return hasPermission(role, 'canAccessAdminDashboard')
}

/**
 * Check if user can create content
 * @param role - The user's role
 * @returns true if user can create content
 */
export function canCreateContent(role: UserRole): boolean {
  return hasPermission(role, 'canCreateContent')
}

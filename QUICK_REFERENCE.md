# Quick Reference Guide

## Login Credentials (Copy & Paste)

### Admin Account
```
Email:    admin@thinkthonk.com
Password: Admin123!@#
```

### User Account
```
Email:    demo@thinkthonk.com
Password: Demo123!@#
```

---

## What Each Account Can Do

| Feature | Admin | User |
|---------|-------|------|
| View home feed | ✅ | ✅ |
| Like ideas | ✅ | ✅ |
| Save ideas | ✅ | ✅ |
| Access admin dashboard | ✅ | ❌ |
| Create ideas | ✅ | ❌ |
| Use form fields mode | ✅ | ❌ |
| Use JSON mode | ✅ | ❌ |
| Publish ideas | ✅ | ❌ |

---

## Quick Routes

| Page | URL | Who Can Access |
|------|-----|----------------|
| Home | `/` | Everyone |
| Login | `/auth` | Everyone |
| Profile | `/profile` | Logged in users |
| Admin | `/admin` | Admin only |
| Saved | `/saved` | Logged in users |
| Settings | `/settings` | Logged in users |

---

## Testing Checklist

### Login & Logout
- [ ] Login as admin
- [ ] See "Admin Dashboard" in profile menu
- [ ] Logout successfully
- [ ] Login as user
- [ ] Don't see "Admin Dashboard" link
- [ ] Logout successfully

### Admin Features
- [ ] Access admin dashboard as admin
- [ ] Click "New Idea"
- [ ] Fill form in Fields mode
- [ ] Publish idea
- [ ] Switch to JSON mode
- [ ] Paste JSON and publish
- [ ] See both ideas on home page

### Access Control
- [ ] Try to visit `/admin` as user
- [ ] Get redirected to home
- [ ] Login as admin
- [ ] Access `/admin` successfully
- [ ] See dashboard with ideas

### Profile
- [ ] View profile after login
- [ ] See logged-in user's name & email
- [ ] See admin button for admin user
- [ ] See no admin button for regular user
- [ ] Logout from profile

---

## API Reference (In Code)

### AuthService methods

```javascript
// Login
AuthService.login(email, password)
// Returns: { success, message, session, error }

// Register
AuthService.register(email, password, name)
// Returns: { success, message, error }

// Logout
AuthService.logout()

// Get current user
AuthService.getCurrentUser()
// Returns: { id, email, name, role, createdAt }

// Check if admin
AuthService.isAdmin()
// Returns: boolean

// Check if authenticated
AuthService.isAuthenticated()
// Returns: boolean

// Get test credentials
AuthService.getTestCredentials()
// Returns: { admin: {...}, user: {...} }
```

---

## Files to Know

### Main Files
- `lib/services/auth_service.ts` - Authentication logic
- `app/auth/page.tsx` - Login page
- `components/admin/admin-role-guard.tsx` - Route protection
- `app/admin/page.tsx` - Admin dashboard

### Models
- `lib/models/role_model.ts` - User roles
- `lib/models/content_model.ts` - Idea types

### Tests
- Test as admin: Use `admin@thinkthonk.com`
- Test as user: Use `demo@thinkthonk.com`
- Test guest: Don't login, try to access `/admin`

---

## Common Issues

| Issue | Solution |
|-------|----------|
| Can't login | Check email/password spelling, use exact credentials |
| Session lost | Sessions expire after 24 hours, login again |
| Can't access admin | Must be logged in as admin account |
| Ideas not showing | Refresh page, ensure status is "published" |
| Weird auth state | Clear localStorage: `localStorage.clear()` |

---

## Developer Commands

### Check Current User (in browser console)
```javascript
import AuthService from '@/lib/services/auth_service'
AuthService.getCurrentUser()
```

### Check if Admin
```javascript
import AuthService from '@/lib/services/auth_service'
AuthService.isAdmin()
```

### Get Test Credentials
```javascript
import AuthService from '@/lib/services/auth_service'
AuthService.getTestCredentials()
```

### Clear Session
```javascript
localStorage.clear()
window.location.href = '/auth'
```

---

## Files Map

```
Think Thonk App
├── Home Feed
│   └── Like/Save ideas
├── Authentication
│   ├── Login page (/auth)
│   ├── Register page (/auth)
│   └── Session management
├── Admin (Protected Route)
│   ├── Create ideas
│   ├── Form fields mode
│   ├── JSON mode
│   └── Manage ideas
├── Profile (/profile)
│   ├── View user info
│   ├── Edit profile
│   └── Logout
└── Other Pages
    ├── Saved articles (/saved)
    └── Settings (/settings)
```

---

## Next Steps After Testing

1. Read `GETTING_STARTED.md` for detailed walkthroughs
2. Read `AUTH_SETUP.md` for production migration guide
3. Read `ADMIN_FEATURES.md` for admin features details
4. Check `FLUTTER_MIGRATION_GUIDE.md` to build Flutter app
5. Plan database setup for production

---

## Important Files

| File | Purpose |
|------|---------|
| `AUTH_SETUP.md` | Auth setup & migration |
| `GETTING_STARTED.md` | Feature overview & quick start |
| `AUTH_IMPLEMENTATION_SUMMARY.md` | What was built (this session) |
| `ADMIN_FEATURES.md` | Admin feature details |
| `README.md` | Project overview |

---

**Version**: 3.0  
**Status**: Ready to Test  
**Last Updated**: March 13, 2026

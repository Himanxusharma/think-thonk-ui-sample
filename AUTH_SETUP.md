# Authentication Setup Guide

## Overview

The application uses a lightweight authentication system with two hardcoded test users for development. This is designed to be easily replaced with a real database when you're ready.

## Test Credentials

### Admin Account
- **Email**: `admin@thinkthonk.com`
- **Password**: `Admin123!@#`
- **Role**: `admin`
- **Access**: Full admin dashboard, create ideas, publish content

### User Account
- **Email**: `demo@thinkthonk.com`
- **Password**: `Demo123!@#`
- **Role**: `user`
- **Access**: Read-only, cannot access admin features

## How to Test

### 1. Login with Admin Account
1. Go to `/auth` (click "Sign In" if on home page)
2. Enter: `admin@thinkthonk.com` / `Admin123!@#`
3. Click "Sign In"
4. You'll be redirected to the home page
5. Click the user icon (top right) → "Admin Dashboard" to access admin features
6. Or go directly to `/admin`

### 2. Login with User Account
1. Go to `/auth`
2. Enter: `demo@thinkthonk.com` / `Demo123!@#`
3. Click "Sign In"
4. You'll see the home page without admin features
5. The user menu won't show "Admin Dashboard"

### 3. Logout
1. Click user icon (top right)
2. Click "Logout"
3. You'll be redirected to `/auth`

## Features by Role

### Admin (admin@thinkthonk.com)
✅ View admin dashboard (`/admin`)  
✅ Create new ideas  
✅ Use form fields mode  
✅ Use JSON editor mode  
✅ Publish ideas immediately  
✅ See admin link in profile menu  
✅ See admin button on profile page  

### Regular User (demo@thinkthonk.com)
❌ Cannot access `/admin` (redirected to home)  
❌ No admin menu items  
❌ Cannot create ideas  
✅ Can read all ideas  
✅ Can like/save ideas  

## Authentication Flow

```
Login Page (/auth)
      ↓
AuthService.login(email, password)
      ↓
Validate credentials (check TEST_USERS)
      ↓
Generate session token
      ↓
Store in localStorage
      ↓
Redirect to home page
```

## Session Management

Sessions are stored in browser localStorage:
- `auth_session`: Full session object with user data
- `auth_token`: JWT-like token (development only)
- `Expiry`: 24 hours

To manually clear session (for testing):
```javascript
// In browser console
localStorage.removeItem('auth_session')
localStorage.removeItem('auth_token')
window.location.href = '/auth'
```

## File Structure

### Core Files
- `lib/services/auth_service.ts` - Authentication logic
- `app/auth/page.tsx` - Login/Register page
- `components/admin/admin-role-guard.tsx` - Route protection

### Related Files
- `lib/models/role_model.ts` - User role definitions
- `lib/services/admin_service.ts` - Uses auth for admin checks
- `components/profile-menu.tsx` - Shows admin link if user is admin
- `app/profile/page.tsx` - Profile with user data from auth

## Migrating to Real Database

When you're ready to use a real database:

### 1. Replace Test Users
In `lib/services/auth_service.ts`:
```typescript
// Replace this:
const user = TEST_USERS.find((u) => u.email === email)

// With this:
const user = await db.users.findOne({ email })
```

### 2. Add Password Hashing
```typescript
// Install: npm install bcryptjs
import bcrypt from 'bcryptjs'

// Replace:
if (user.password !== password)

// With:
if (!await bcrypt.compare(password, user.passwordHash))
```

### 3. Use Real Tokens
```typescript
// Install: npm install jsonwebtoken
import jwt from 'jsonwebtoken'

// Replace token generation
const token = jwt.sign(
  { userId: user.id },
  process.env.JWT_SECRET,
  { expiresIn: '24h' }
)
```

### 4. Database Schema
```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  name VARCHAR(255),
  password_hash VARCHAR(255) NOT NULL,
  role VARCHAR(50) DEFAULT 'user',
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
)

CREATE INDEX idx_users_email ON users(email)
```

## Environment Variables (When Using Database)

Add these to `.env.local`:
```
DATABASE_URL=your_database_url
JWT_SECRET=your_jwt_secret
SESSION_TIMEOUT=86400
```

## Security Notes

### Development Only
- Test users are hardcoded (for easy testing)
- No bcrypt hashing
- Simple token generation
- localStorage storage (not secure for production)

### Production Requirements
- [ ] Use bcrypt for password hashing
- [ ] Use JWT with RS256 signing
- [ ] Move sessions to secure, httpOnly cookies
- [ ] Add rate limiting on login attempts
- [ ] Add email verification for registration
- [ ] Add password reset flow
- [ ] Use HTTPS only
- [ ] Add CSRF protection
- [ ] Add 2FA support

## Troubleshooting

### "User not found" error
- Check email spelling (case-sensitive)
- Use exact test credentials provided above
- Make sure you're in development (not production)

### "Invalid password" error
- Check password spelling (case-sensitive)
- Use exact test credentials provided above
- Passwords include special characters (@, #, !)

### Can't access admin dashboard
- Ensure you're logged in as admin user
- Check browser console for errors
- Clear localStorage and login again: 
  ```javascript
  localStorage.clear()
  ```

### Session expires unexpectedly
- Check localStorage for `auth_session`
- Current expiry is 24 hours
- Clear and login again if needed

## Testing Checklist

- [ ] Admin login works
- [ ] User login works
- [ ] Admin sees dashboard link
- [ ] User doesn't see dashboard link
- [ ] Cannot access `/admin` as user
- [ ] Can access `/admin` as admin
- [ ] Profile shows correct user info
- [ ] Logout clears session
- [ ] Profile shows admin role for admin user
- [ ] Form validation works in admin
- [ ] Can create ideas as admin
- [ ] Ideas persist in component state

## Support

For issues or questions, refer to:
- `ADMIN_FEATURES.md` - Admin feature details
- `ADMIN_FEATURE_QUICKSTART.md` - Quick start guide
- `lib/services/auth_service.ts` - Implementation details

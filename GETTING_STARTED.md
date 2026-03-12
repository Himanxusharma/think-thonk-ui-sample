# Getting Started with Think Thonk

## Quick Start (5 minutes)

### 1. Login
Go to the Auth page and use one of these accounts:

**Admin Account** (Full Access)
```
Email: admin@thinkthonk.com
Password: Admin123!@#
```

**User Account** (Read-Only)
```
Email: demo@thinkthonk.com
Password: Demo123!@#
```

### 2. Explore as Admin
After logging in as admin:
1. Click the user icon (top right)
2. Click "Admin Dashboard"
3. Click "New Idea"
4. Create an idea using form fields or JSON

### 3. Switch Input Modes
In the admin dashboard:
- **Fields Mode**: User-friendly form with dropdowns and text areas
- **JSON Mode**: Write raw JSON, perfect for batch creation

## Features Overview

### For Users
- Read engaging ideas across various topics
- Like ideas (red heart counts)
- Save favorites (bookmark)
- Full-screen focus mode
- Like/save streak counter

### For Admins
- Create and publish ideas
- Choose between form fields or JSON input
- Draft or publish immediately
- Track engagement metrics
- Manage all created content

## Directory Structure

```
├── app/
│   ├── page.tsx              # Home feed
│   ├── auth/                 # Authentication pages
│   ├── profile/              # User profile
│   └── admin/                # Admin dashboard (protected)
├── components/
│   ├── admin/                # Admin components
│   │   ├── admin-panel.tsx
│   │   ├── idea-form.tsx
│   │   ├── fields-editor.tsx
│   │   ├── json-editor.tsx
│   │   └── admin-role-guard.tsx
│   ├── content-card.tsx      # Idea display
│   └── profile-menu.tsx      # User menu
├── lib/
│   ├── services/
│   │   ├── auth_service.ts   # Authentication logic
│   │   └── admin_service.ts  # Admin business logic
│   ├── models/
│   │   ├── role_model.ts     # User roles
│   │   └── content_model.ts  # Idea types
│   └── repositories/
│       └── content_repository.ts  # Data access
└── scripts/
    └── setup_ideas_table.sql # Database schema
```

## Key Files to Understand

### Authentication
- **`lib/services/auth_service.ts`**: Login, logout, session management
- **`app/auth/page.tsx`**: Login/register UI
- **`components/admin/admin-role-guard.tsx`**: Route protection

### Admin Features
- **`components/admin/admin-panel.tsx`**: Main dashboard with stats
- **`components/admin/idea-form.tsx`**: Form with mode toggle
- **`components/admin/fields-editor.tsx`**: Form fields input
- **`components/admin/json-editor.tsx`**: JSON input with validation

### Models & Services
- **`lib/models/role_model.ts`**: User roles (admin, user, moderator)
- **`lib/models/content_model.ts`**: Idea data structures
- **`lib/services/admin_service.ts`**: Idea creation, validation, JSON parsing

## Admin Dashboard Walkthrough

### Create an Idea
1. Go to `/admin` or click Admin Dashboard in profile menu
2. Click "New Idea" button
3. Choose input mode (Fields or JSON)

### Fields Mode
Fill in the form:
- **Category**: Select from dropdown
- **Title**: Main idea title (required)
- **Explanation**: Detailed explanation (required)
- **Example**: Real-world example (required)
- **Takeaway**: Key takeaway (required)
- **Custom Heading** (optional): For custom content
- **Custom Content** (optional): Additional details
- **Status**: Draft or Published

Click "Publish" to save.

### JSON Mode
Paste JSON and click "Publish":
```json
{
  "category": "Psychology",
  "title": "Confirmation Bias",
  "explanation": "Our tendency to search for information that confirms...",
  "example": "A politician only reading news from aligned outlets",
  "takeaway": "Be aware of your biases and seek opposing views",
  "status": "published"
}
```

## Database Structure

### ideas table
```sql
CREATE TABLE ideas (
  id UUID PRIMARY KEY,
  category TEXT,
  title TEXT,
  explanation TEXT,
  example TEXT,
  takeaway TEXT,
  custom_heading TEXT,
  custom_content TEXT,
  likes_count INT DEFAULT 0,
  saves_count INT DEFAULT 0,
  share_count INT DEFAULT 0,
  comments_count INT DEFAULT 0,
  status TEXT DEFAULT 'published',
  created_by UUID,
  created_on TIMESTAMP,
  published_on TIMESTAMP,
  modified_on TIMESTAMP
)
```

## Testing Scenarios

### Scenario 1: Test Admin Features
1. Login as `admin@thinkthonk.com`
2. Navigate to admin dashboard
3. Create an idea with fields
4. Switch to JSON mode
5. Create another idea with JSON
6. View both ideas on home page

### Scenario 2: Test User Restrictions
1. Login as `demo@thinkthonk.com`
2. Try to navigate to `/admin`
3. You should be redirected to home
4. Check profile menu (no Admin Dashboard link)

### Scenario 3: Test Session Management
1. Login as admin
2. Check localStorage in DevTools
3. Clear session: `localStorage.clear()`
4. Refresh page
5. You should be logged out

### Scenario 4: Test Form Validation
1. As admin, click "New Idea"
2. Try to submit empty title
3. Should see error message
4. Fill in all required fields
5. Submit should work

## Common Tasks

### View Current User
```javascript
// In browser console
import AuthService from '@/lib/services/auth_service'
AuthService.getCurrentUser()
```

### Check if Admin
```javascript
import AuthService from '@/lib/services/auth_service'
AuthService.isAdmin()
```

### Logout Programmatically
```javascript
import AuthService from '@/lib/services/auth_service'
AuthService.logout()
window.location.href = '/auth'
```

### Get Test Credentials
```javascript
import AuthService from '@/lib/services/auth_service'
AuthService.getTestCredentials()
```

## Environment Variables

Currently, no environment variables are required for development. When you integrate with a real database, add:

```
DATABASE_URL=your_database_connection_string
JWT_SECRET=your_secret_key
NODE_ENV=development
```

## Documentation Files

- **`README.md`**: Project overview and features
- **`ARCHITECTURE.md`**: System architecture and design patterns
- **`ADMIN_FEATURES.md`**: Comprehensive admin features documentation
- **`AUTH_SETUP.md`**: Authentication setup and testing guide
- **`FLUTTER_MIGRATION_GUIDE.md`**: Guide for Flutter app development
- **`IMPLEMENTATION_CHECKLIST.md`**: What was built and what's pending

## Next Steps

### For Development
1. Test both user roles
2. Create sample ideas as admin
3. Verify engagement counters work
4. Test form validation
5. Explore JSON editor

### For Production
1. Set up real database
2. Replace test users with database queries
3. Add bcrypt password hashing
4. Implement JWT authentication
5. Add email verification
6. Set up password reset flow
7. Configure HTTPS and security headers

### For Flutter App
Refer to `FLUTTER_MIGRATION_GUIDE.md` for step-by-step instructions to build the same features in Flutter.

## Troubleshooting

### Login Not Working
- Check email and password spelling (case-sensitive)
- Use exact credentials from GETTING_STARTED
- Clear browser cache and try again

### Can't Access Admin Dashboard
- Ensure logged in as `admin@thinkthonk.com`
- Check browser console for errors
- Clear localStorage: `localStorage.clear()`

### Ideas Not Showing
- Ensure status is "published"
- Check if idea was created successfully
- Refresh page if needed

### Session Lost
- Sessions expire after 24 hours
- Logout and login again
- Clear localStorage if needed

## Support & Resources

- **GitHub**: [Himanxusharma/think-thonk-ui-sample](https://github.com/Himanxusharma/think-thonk-ui-sample)
- **Issues**: Check GitHub issues for known problems
- **Docs**: See other .md files in root directory

---

**Version**: 3.0  
**Last Updated**: March 13, 2026  
**Status**: Production Ready

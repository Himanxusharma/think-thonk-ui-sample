# Test Credentials - Admin & User Accounts

This file contains test credentials and instructions for testing both admin and general user accounts.

## Overview

The app uses localStorage-based role detection for testing. In production, this should be replaced with actual authentication and backend role verification.

---

## Test Credentials

### Admin Account
```
Name: Admin User
Email: admin@thinkthonk.com
Role: admin
Password: (not required for testing - localStorage based)
```

**Features Access:**
- ✅ Admin Dashboard (`/admin`)
- ✅ Create Ideas (form fields or JSON mode)
- ✅ Publish ideas directly
- ✅ View in admin menu
- ✅ Admin button on profile page

### Regular User Account
```
Name: Demo User
Email: demo@thinkthonk.com
Role: user
Password: (not required for testing - localStorage based)
```

**Features Access:**
- ❌ No admin dashboard access
- ❌ Cannot create ideas
- ❌ No admin menu items
- ❌ No admin button on profile page
- ✅ Can view published ideas
- ✅ Can like/save ideas
- ✅ Can access profile

---

## How to Test

### Switch to Admin Account

**Method 1: Using Browser Console**

1. Open your browser's Developer Tools (`F12` or `Right-click → Inspect`)
2. Go to the **Console** tab
3. Paste and run:
```javascript
localStorage.setItem('isAdmin', 'true')
localStorage.setItem('userEmail', 'admin@thinkthonk.com')
localStorage.setItem('userName', 'Admin User')
```
4. Refresh the page (`F5`)
5. You should now see:
   - "Admin Dashboard" link in profile menu
   - "Admin Dashboard" button on profile page
   - Access to `/admin` route

### Switch to Regular User Account

**Method 1: Using Browser Console**

1. Open Developer Tools (`F12`)
2. Go to **Console** tab
3. Paste and run:
```javascript
localStorage.setItem('isAdmin', 'false')
localStorage.setItem('userEmail', 'demo@thinkthonk.com')
localStorage.setItem('userName', 'Demo User')
```
4. Refresh the page (`F5`)
5. All admin features will be hidden/disabled

**Method 2: Clear All Settings**

To fully reset and remove admin access:
```javascript
localStorage.clear()
location.reload()
```

---

## Testing Workflows

### Test 1: Admin Creates Idea (Form Fields Mode)

1. **Enable admin**: Run admin credentials command
2. **Navigate**: Click profile icon → "Admin Dashboard"
3. **Create Idea**: Click "New Idea"
4. **Fill Form**:
   - Category: "Psychology"
   - Title: "Understanding Cognitive Biases"
   - Explanation: "Cognitive biases are systematic patterns of deviation from rational judgment..."
   - Example: "Confirmation bias: tendency to search for information that confirms existing beliefs"
   - Takeaway: "Being aware of our biases helps us make better decisions"
   - Status: "Published"
5. **Submit**: Click "Publish Idea"
6. **Verify**: See success message and idea appears in dashboard

### Test 2: Admin Creates Idea (JSON Mode)

1. **Enable admin**: Run admin credentials command
2. **Navigate**: Click profile icon → "Admin Dashboard"
3. **Create Idea**: Click "New Idea"
4. **Toggle Mode**: Click "JSON Mode"
5. **Paste JSON**:
```json
{
  "category": "Neuroscience",
  "title": "Neuroplasticity Explained",
  "explanation": "The brain's ability to reorganize itself by forming new neural connections throughout life.",
  "example": "Learning a new language activates different brain regions and strengthens neural pathways.",
  "takeaway": "Your brain can change and adapt at any age with practice and learning.",
  "customHeading": "The Brain's Flexibility",
  "customContent": "This concept revolutionized our understanding of brain development.",
  "status": "published"
}
```
6. **Submit**: Click "Publish Idea"
7. **Verify**: See success message and idea appears in dashboard

### Test 3: User Cannot Access Admin Features

1. **Enable user mode**: Run regular user credentials command
2. **Try accessing**: Go directly to `/admin` in URL bar
3. **Verify**: Should see "Access Denied" message or redirect
4. **Check Profile**: 
   - No "Admin Dashboard" link in dropdown menu
   - No "Admin Dashboard" button on profile page

### Test 4: Form Validation

1. **Enable admin**: Run admin credentials command
2. **Navigate**: Click profile icon → "Admin Dashboard"
3. **Create Idea**: Click "New Idea"
4. **Try submitting empty form**: Click "Publish Idea"
5. **Verify**: See validation error messages
6. **Fill required fields** and try again
7. **Verify**: Form submits successfully

---

## Browser Storage (localStorage)

All test data is stored in browser localStorage. Here's what gets stored:

```javascript
// When admin is enabled:
localStorage.isAdmin = 'true'
localStorage.userEmail = 'admin@thinkthonk.com'
localStorage.userName = 'Admin User'

// When user is enabled:
localStorage.isAdmin = 'false'
localStorage.userEmail = 'demo@thinkthonk.com'
localStorage.userName = 'Demo User'
```

**Note**: localStorage is cleared when you clear browser data/cookies.

---

## Environment Variables (Production Setup)

When moving to production with real authentication, update these files:

1. **`lib/services/admin_service.ts`**
   - Replace `isCurrentUserAdmin()` function
   - Connect to real auth system (Firebase, Supabase, etc.)
   - Verify role from backend/auth provider

2. **`components/profile-menu.tsx`**
   - Replace localStorage check with real auth hook
   - Get user role from auth context/provider

3. **`app/admin/layout.tsx`**
   - Add real authentication redirect
   - Verify JWT token or session
   - Check role on backend

---

## Troubleshooting

### Can't See Admin Features

1. Check localStorage is enabled in your browser
2. Verify you ran the console command correctly
3. Try refreshing the page (`F5` or `Ctrl+R`)
4. Clear localStorage and try again:
```javascript
localStorage.clear()
location.reload()
```

### Admin Page Shows "Access Denied"

1. Verify `localStorage.isAdmin` is set to `'true'` (as string)
2. Check browser console for errors (`F12` → Console tab)
3. Try logging out and back in

### Ideas Not Saving

1. Check if browser console shows any errors
2. Verify all required fields are filled
3. Check network tab to see if API calls are working
4. Try submitting again

---

## Next Steps

### For Development
- Test both form modes thoroughly
- Verify validation works for all edge cases
- Test role-based access control

### For Production
- Replace localStorage with real authentication
- Setup backend API endpoints for idea creation
- Implement database persistence
- Add proper JWT token handling
- Setup role verification on backend
- Add audit logging for admin actions

---

## Related Documentation

- See **ADMIN_FEATURES.md** for comprehensive feature documentation
- See **ADMIN_FEATURE_QUICKSTART.md** for quick testing guide
- See **IMPLEMENTATION_CHECKLIST.md** for implementation status


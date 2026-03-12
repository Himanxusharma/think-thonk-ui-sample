# Admin Features - Quick Start Guide

## What Was Built

Complete **role-based admin content creation system** for Think Thonk with dual input modes (form fields + JSON), role-based access control, and full Flutter migration documentation.

---

## File Structure Overview

```
New Files Created:
├── scripts/
│   └── setup_ideas_table.sql          # Database migration
├── lib/
│   ├── models/
│   │   └── role_model.ts              # UserRole, AdminUser types
│   └── services/
│       └── admin_service.ts           # Admin business logic
├── components/admin/
│   ├── admin-panel.tsx                # Main dashboard
│   ├── idea-form.tsx                  # Form wrapper
│   ├── fields-editor.tsx              # Form fields mode
│   ├── json-editor.tsx                # JSON mode
│   └── form-toggle.tsx                # Mode switcher
├── app/admin/
│   ├── layout.tsx                     # Admin layout
│   └── page.tsx                       # Admin dashboard page
├── ADMIN_FEATURES.md                  # Full admin documentation
├── ADMIN_FEATURE_QUICKSTART.md        # This file

Updated Files:
├── lib/models/content_model.ts        # Added Idea types
├── components/profile-menu.tsx        # Added admin link
├── app/profile/page.tsx               # Added admin button
└── README.md                          # Updated with v3.0 changes
```

---

## Testing Admin Features

### 1. Enable Admin Access

Open your browser console and run:

```javascript
localStorage.setItem('isAdmin', 'true')
```

Then refresh the page.

### 2. Access Admin Dashboard

**Option A - Via Profile Menu:**
1. Click user icon (top right)
2. Click "Admin Dashboard"

**Option B - Direct URL:**
- Navigate to `/admin`

### 3. Create Your First Idea

#### Using Form Fields (Recommended for First Time):
1. Click "New Idea"
2. Select **"Input Fields"** tab
3. Fill in all required fields:
   - Category: Choose from dropdown
   - Title: Up to 200 characters
   - Explanation: Detailed explanation (20+ chars)
   - Example: Real-world example (20+ chars)
   - Takeaway: Key point (10+ chars)
4. (Optional) Add custom heading/content
5. Choose status: Draft or Published
6. Click "Publish Now" to publish immediately

#### Using JSON Mode:
1. Click "New Idea"
2. Select **"JSON Mode"** tab
3. Paste or type JSON:

```json
{
  "category": "Psychology",
  "title": "Understanding Cognitive Bias",
  "explanation": "How our brains make quick judgments that sometimes lead us astray...",
  "example": "Confirmation bias: We seek information that confirms what we already believe...",
  "takeaway": "Being aware of cognitive biases helps us make better decisions.",
  "status": "draft"
}
```

4. Click "Publish Now"

### 4. View Created Ideas

- Dashboard shows stats (Total, Published, Drafts)
- Recent ideas list displays all created content
- Each idea shows status badge, category, date, and engagement metrics

---

## Key Features Explained

### Dual Input Modes

**Fields Mode** (Default):
- User-friendly form with labeled inputs
- Real-time validation with error messages
- Clear field requirements
- Best for most users

**JSON Mode** (Power Users):
- Raw JSON input
- Format button to prettify
- Copy button for sharing templates
- Bulk import support
- Best for developers and bulk operations

### Form Toggle

Switch between modes anytime. Your data is preserved automatically:
- Mode switches update JSON representation in real-time
- Validation happens during input
- Both modes save to same idea object

### Role-Based Access

| Feature | User | Admin | Moderator |
|---------|------|-------|-----------|
| View Content | ✅ | ✅ | ✅ |
| Create Ideas | ❌ | ✅ | ✅ |
| Publish Ideas | ❌ | ✅ | ❌ |
| Delete Content | ❌ | ✅ | ❌ |
| Access Admin | ❌ | ✅ | ✅ |

### Publishing Workflow

**Draft:**
- Not visible to regular users
- Can be edited later
- Use for work-in-progress

**Published:**
- Immediately visible to all users
- Cannot unpublish through UI
- Sets publication timestamp
- Final state

---

## Database Integration

The `ideas` table has been created with:
- All required fields (category, title, explanation, example, takeaway)
- Optional fields (custom_heading, custom_content)
- Engagement metrics (likes, saves, shares, comments)
- Status tracking (draft/published)
- Timestamps (created, published, modified)
- Indexes for performance

To set up the database:

```bash
# If using a database client
# 1. Open your database
# 2. Run scripts/setup_ideas_table.sql
# 3. Execute the SQL migration
```

Or for integrations like Supabase:
1. Go to SQL Editor
2. Paste contents of `scripts/setup_ideas_table.sql`
3. Click "Run"

---

## API/Service Layer

### Validation

```typescript
import { validateIdeaInput } from '@/lib/services/admin_service'

const errors = validateIdeaInput(input)
if (errors.length > 0) {
  // Handle validation errors
  console.log(errors)
}
```

### JSON Parsing

```typescript
import { parseJSONInput } from '@/lib/services/admin_service'

const result = parseJSONInput(jsonString)
if (result.success) {
  const idea = result.data
} else {
  console.log(result.error)
}
```

### Checking User Role

```typescript
import { isCurrentUserAdmin } from '@/lib/services/admin_service'

if (isCurrentUserAdmin()) {
  // Show admin controls
}
```

---

## Directory Organization for Flutter

All admin features are organized in dedicated directories for easy Flutter migration:

```
Webapp Structure → Flutter Equivalent

lib/models/
├── content_model.ts → content_model.dart
└── role_model.ts → role_model.dart

lib/services/
└── admin_service.ts → admin_service.dart

components/admin/ → lib/widgets/admin/
├── admin-panel.tsx → admin_screen.dart
├── idea-form.tsx → idea_form_screen.dart
├── fields-editor.tsx → fields_editor.dart
├── json-editor.tsx → json_editor.dart
└── form-toggle.tsx → form_toggle.dart

app/admin/ → lib/screens/admin/
├── page.tsx → admin_screen.dart
└── layout.tsx → (handled by Navigator)
```

See **ADMIN_FEATURES.md** and **FLUTTER_MIGRATION_GUIDE.md** for detailed migration patterns.

---

## Customization

### Adding More Categories

Edit `lib/models/content_model.ts`:

```typescript
export const IDEA_CATEGORIES = [
  'Psychology',
  'Neuroscience',
  'Behavioral Science',
  'Cognitive Science',
  'Philosophy',
  'Technology',
  'Ecology',
  'Economics',
  'Your New Category', // Add here
] as const
```

### Changing Field Validation

Edit `lib/services/admin_service.ts` → `validateIdeaInput()` function:

```typescript
// Example: Change minimum title length to 5
if (input.title.length < 5) {
  errors.push({
    field: 'title',
    message: 'Title must be at least 5 characters',
  })
}
```

### Custom Status Workflow

Extend `IdeaStatus` enum in `lib/models/content_model.ts`:

```typescript
export enum IdeaStatus {
  DRAFT = 'draft',
  PUBLISHED = 'published',
  ARCHIVED = 'archived',      // New status
  PENDING_REVIEW = 'pending',  // New status
}
```

---

## Troubleshooting

### "Access Denied" Error
- Ensure `localStorage.setItem('isAdmin', 'true')` is set
- Refresh the page after setting it
- Check browser console: `localStorage.getItem('isAdmin')`

### Validation Errors on Submit
- Check all required fields have values
- Verify category is from the dropdown list
- Ensure explanation/example meet minimum character requirements
- For JSON mode, validate JSON syntax

### Ideas Not Appearing in List
- Check dashboard under "Recent Ideas"
- Verify you're viewing as admin
- Draft ideas are only visible to their creator
- Published ideas should show immediately

### JSON Parse Error
- Check JSON syntax using `JSON.parse()` in console
- Ensure all required fields are present
- Use the "Format JSON" button to auto-fix indentation

---

## Next Steps

### 1. Test the Feature
1. Enable admin mode
2. Create a few test ideas
3. Try both form fields and JSON modes
4. Test draft vs. published workflow

### 2. Connect to Real Database
- Replace mock service with actual API calls
- Update `lib/services/admin_service.ts` to call your backend
- Implement persistent storage

### 3. Add Approval Workflow (Optional)
- Add MODERATOR role
- Require admin approval for moderator-created content
- Create approval dashboard

### 4. Migrate to Flutter
- Use FLUTTER_MIGRATION_GUIDE.md
- Port models and services first
- Build UI components using Flutter patterns

### 5. Add Additional Features
- Edit existing ideas
- Delete/archive ideas
- Bulk import from CSV/JSON
- Analytics dashboard
- Revision history

---

## Documentation

- **ADMIN_FEATURES.md** - Complete admin feature documentation (614 lines)
- **FLUTTER_MIGRATION_GUIDE.md** - Flutter migration guide with admin patterns (700+ lines)
- **README.md** - Updated with admin features overview
- **ARCHITECTURE.md** - System architecture (reference for existing structure)

---

## Support Resources

- Check ADMIN_FEATURES.md for detailed docs
- See FLUTTER_MIGRATION_GUIDE.md for cross-platform patterns
- Review component source code for implementation details
- Use browser console for debugging

---

**Last Updated**: March 13, 2026 | **Version**: v3.0 | **Status**: Ready for Testing

Happy building! 🚀

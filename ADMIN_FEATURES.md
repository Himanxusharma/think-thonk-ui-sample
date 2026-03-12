# Admin Features Documentation

## Overview

The Admin Features module enables role-based content creation within the Think Thonk platform. Only users with the `admin` role can access the admin dashboard and create ideas that are published to the platform.

This documentation covers the admin feature architecture, usage, and Flutter migration patterns.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Role-Based Access Control](#role-based-access-control)
3. [Admin Dashboard](#admin-dashboard)
4. [Content Creation](#content-creation)
5. [Database Schema](#database-schema)
6. [API & Services](#api--services)
7. [Flutter Migration](#flutter-migration)

---

## Quick Start

### Accessing Admin Dashboard

1. **Login** with any account
2. **Go to Profile** (click user icon in top right)
3. Click **"Admin Dashboard"** button (only visible if user is admin)
   - Or navigate directly to `/admin`

### Demo Admin Access

For testing purposes, enable admin access in your browser console:

```javascript
localStorage.setItem('isAdmin', 'true')
```

Then refresh the page to access the admin dashboard.

### Creating Your First Idea

1. Click **"New Idea"** button on the dashboard
2. Choose input mode:
   - **Input Fields**: User-friendly form with dropdown and text areas
   - **JSON Mode**: Paste or write raw JSON
3. Fill in all required fields:
   - Category
   - Title
   - Explanation
   - Example
   - Takeaway
4. (Optional) Add custom heading and content
5. Choose status: Draft or Published
6. Click **"Save as Draft"** or **"Publish Now"**

---

## Role-Based Access Control

### User Roles

```typescript
enum UserRole {
  USER = 'user',           // Default role - no special permissions
  ADMIN = 'admin',         // Full content creation and publishing
  MODERATOR = 'moderator', // Can create content but requires approval
}
```

### Permissions Matrix

| Permission | User | Admin | Moderator |
|-----------|------|-------|-----------|
| Create Content | ❌ | ✅ | ✅ |
| Publish Content | ❌ | ✅ | ❌ |
| Delete Content | ❌ | ✅ | ❌ |
| Moderate Comments | ❌ | ✅ | ✅ |
| Access Admin Dashboard | ❌ | ✅ | ✅ |

### Checking User Role

```typescript
import { isCurrentUserAdmin, canCreateContent } from '@/lib/services/admin_service'

// Check if user is admin
if (isCurrentUserAdmin()) {
  // Show admin UI
}

// Check specific permission
if (canCreateContent(userRole)) {
  // Show content creation button
}
```

---

## Admin Dashboard

### Dashboard Features

#### 1. **Stats Overview**
- **Total Ideas**: All ideas created by this admin
- **Published**: Number of published ideas
- **Drafts**: Number of draft ideas

#### 2. **Create New Idea**
- Click "New Idea" to show the creation form
- Form supports both input fields and JSON modes
- Real-time validation with error messages

#### 3. **Recent Ideas List**
- Shows all ideas created by this admin
- Displays status (Published/Draft) with color coding
- Shows engagement metrics (likes, saves, shares)
- Sorted by creation date (newest first)

#### 4. **Empty State**
- When no ideas exist, shows helpful prompt to create first idea

### Component Structure

```
AdminPanel (main container, state management)
├── FormToggle (mode switcher)
├── IdeaForm (form wrapper)
│   ├── FieldsEditor (when in FIELDS mode)
│   └── JSONEditor (when in JSON mode)
└── Ideas List (recent ideas display)
```

---

## Content Creation

### Input Modes

#### **Fields Mode** (Default)

User-friendly form with dedicated input fields:

- **Category** (required): Dropdown with predefined categories
- **Title** (required): Up to 200 characters
- **Explanation** (required): 20+ characters, detailed explanation
- **Example** (required): 20+ characters, real-world example
- **Key Takeaway** (required): 10+ characters, main point
- **Custom Heading** (optional): Additional section heading
- **Custom Content** (optional): Additional section content
- **Status**: Draft or Published radio buttons

**Advantages**:
- User-friendly interface
- Built-in validation
- Clear field labels
- Error messages for each field
- Suitable for most admins

#### **JSON Mode**

Raw JSON input for power users:

```json
{
  "category": "Psychology",
  "title": "The Horse Effect Theory",
  "explanation": "Understanding how our brains process information through metaphorical thinking...",
  "example": "A breakthrough study reveals patterns in how successful individuals visualize complex problems...",
  "takeaway": "Our ancient relationship with animals has shaped our cognitive architecture...",
  "customHeading": "Additional Context",
  "customContent": "Extended information goes here...",
  "status": "draft"
}
```

**Advantages**:
- Bulk import/export support
- Integration with external tools
- Copy/paste from templates
- Suitable for advanced users

**Features**:
- Auto-validation while typing
- Format button to prettify JSON
- Copy button for sharing
- Real-time error feedback

### Validation Rules

All fields are validated both on client and server:

| Field | Rules |
|-------|-------|
| category | Required, must be from predefined list |
| title | Required, max 200 chars |
| explanation | Required, min 20 chars |
| example | Required, min 20 chars |
| takeaway | Required, min 10 chars |
| customHeading | Optional, max 200 chars |
| customContent | Optional, no limit |
| status | Must be 'draft' or 'published' |

### Publishing Workflow

1. **Draft Save**
   - Saves idea with `status = 'draft'`
   - Not visible to regular users
   - Can be edited later
   - Shows success message

2. **Publish Now**
   - Saves idea with `status = 'published'`
   - Immediately visible to all users
   - Sets `publishedOn` timestamp
   - Cannot unpublish through UI

---

## Database Schema

### Ideas Table

```sql
CREATE TABLE ideas (
  id UUID PRIMARY KEY,
  
  -- Content fields
  category TEXT NOT NULL,
  title TEXT NOT NULL,
  explanation TEXT NOT NULL,
  example TEXT NOT NULL,
  takeaway TEXT NOT NULL,
  custom_heading TEXT,
  custom_content TEXT,
  
  -- Engagement metrics
  likes_count INT DEFAULT 0,
  saves_count INT DEFAULT 0,
  share_count INT DEFAULT 0,
  comments_count INT DEFAULT 0,
  
  -- Publishing
  status TEXT DEFAULT 'draft',
  created_by UUID,
  
  -- Timestamps
  created_on TIMESTAMP DEFAULT NOW(),
  published_on TIMESTAMP,
  modified_on TIMESTAMP DEFAULT NOW()
)
```

### Indexes

```sql
CREATE INDEX idx_ideas_status ON ideas(status);
CREATE INDEX idx_ideas_category ON ideas(category);
CREATE INDEX idx_ideas_created_by ON ideas(created_by);
CREATE INDEX idx_ideas_created_on ON ideas(created_on DESC);
CREATE INDEX idx_ideas_published_on ON ideas(published_on DESC);
```

### Views

```sql
CREATE VIEW published_ideas AS
SELECT * FROM ideas WHERE status = 'published' ORDER BY published_on DESC;
```

---

## API & Services

### Admin Service Layer

Location: `lib/services/admin_service.ts`

#### Core Functions

```typescript
// Create a new idea
async function createIdea(
  input: AdminIdeaInput,
  userId: string
): Promise<AdminActionResponse<Idea>>

// Publish a draft idea
async function publishIdea(ideaId: string): Promise<AdminActionResponse<Idea>>

// Save as draft
async function saveDraft(
  input: AdminIdeaInput,
  userId: string
): Promise<AdminActionResponse<Idea>>

// Validate input
function validateIdeaInput(input: AdminIdeaInput): IdeaValidationError[]

// Parse JSON input
function parseJSONInput(jsonString: string): AdminActionResponse<AdminIdeaInput>

// Convert input to JSON
function ideaInputToJSON(input: AdminIdeaInput): string

// Check user role
function isCurrentUserAdmin(): boolean
function getCurrentUserRole(): string
```

### Data Models

Location: `lib/models/content_model.ts`

```typescript
// Input from admin form
interface AdminIdeaInput {
  category: string
  title: string
  explanation: string
  example: string
  takeaway: string
  customHeading?: string
  customContent?: string
  status: IdeaStatus
}

// Stored in database
interface Idea extends AdminIdeaInput {
  id: string
  likesCount: number
  savesCount: number
  shareCount: number
  commentsCount: number
  createdBy: string
  createdOn: Date
  publishedOn?: Date
  modifiedOn: Date
}

// Response wrapper
interface AdminActionResponse<T> {
  success: boolean
  data?: T
  error?: string
  errors?: IdeaValidationError[]
}
```

### Role Models

Location: `lib/models/role_model.ts`

```typescript
enum UserRole {
  USER = 'user',
  ADMIN = 'admin',
  MODERATOR = 'moderator',
}

interface AdminUser extends UserProfile {
  role: UserRole
}

// Utility functions
function hasPermission(role: UserRole, permission: keyof RolePermission): boolean
function canAccessAdmin(role: UserRole): boolean
function canCreateContent(role: UserRole): boolean
```

---

## Flutter Migration

### Directory Structure in Flutter

```
lib/
├── models/
│   ├── content_model.dart       # Idea, AdminIdeaInput, etc.
│   └── role_model.dart          # UserRole, AdminUser
├── services/
│   ├── admin_service.dart       # Business logic
│   └── auth_service.dart        # Role/auth info
├── repositories/
│   └── idea_repository.dart     # Database access
├── screens/
│   └── admin/
│       ├── admin_screen.dart
│       ├── idea_form_screen.dart
│       └── admin_dashboard.dart
├── widgets/
│   └── admin/
│       ├── form_toggle.dart
│       ├── fields_editor.dart
│       ├── json_editor.dart
│       └── idea_card.dart
└── constants/
    └── admin_constants.dart
```

### Dart Type Equivalents

| TypeScript | Dart |
|-----------|------|
| `enum` | `enum` |
| `interface` | `abstract class` / `Freezed class` |
| `Promise<T>` | `Future<T>` |
| `Record` | `class` with `@freezed` |
| `undefined` | `null` |

### Validation Translation

```dart
// TypeScript
export function validateIdeaInput(input: AdminIdeaInput): IdeaValidationError[] {
  const errors: IdeaValidationError[] = []
  if (!input.category) {
    errors.push({ field: 'category', message: 'Required' })
  }
  return errors
}

// Dart
List<IdeaValidationError> validateIdeaInput(AdminIdeaInput input) {
  final errors = <IdeaValidationError>[];
  if (input.category.isEmpty) {
    errors.add(IdeaValidationError(field: 'category', message: 'Required'));
  }
  return errors;
}
```

### Component Translation

```dart
// TypeScript (React)
export default function FormToggle({ mode, onModeChange }) {
  return (
    <button onClick={() => onModeChange(IdeaFormMode.FIELDS)}>
      Input Fields
    </button>
  )
}

// Dart (Flutter)
class FormToggle extends StatelessWidget {
  final IdeaFormMode mode;
  final Function(IdeaFormMode) onModeChange;

  const FormToggle({required this.mode, required this.onModeChange});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onModeChange(IdeaFormMode.fields),
      child: const Text('Input Fields'),
    );
  }
}
```

### State Management in Flutter

Use Riverpod or GetX for admin state:

```dart
// Riverpod provider for admin panel state
final adminPanelProvider = StateNotifierProvider<AdminPanelNotifier, AdminPanelState>((ref) {
  return AdminPanelNotifier();
});

class AdminPanelNotifier extends StateNotifier<AdminPanelState> {
  AdminPanelNotifier() : super(AdminPanelState.initial());

  Future<void> createIdea(AdminIdeaInput input) async {
    final response = await AdminService.createIdea(input, userId);
    state = state.copyWith(ideas: [...state.ideas, response.data]);
  }
}
```

### Service Layer Migration

Keep admin service pure (no Flutter imports):

```dart
// lib/services/admin_service.dart
class AdminService {
  // Pure functions - no BuildContext, no UI imports
  static List<IdeaValidationError> validateIdeaInput(AdminIdeaInput input) {
    final errors = <IdeaValidationError>[];
    if (input.category.isEmpty) {
      errors.add(IdeaValidationError(field: 'category', message: 'Required'));
    }
    return errors;
  }

  static Future<AdminActionResponse<Idea>> createIdea(
    AdminIdeaInput input,
    String userId,
  ) async {
    final errors = validateIdeaInput(input);
    if (errors.isNotEmpty) {
      return AdminActionResponse(
        success: false,
        errors: errors,
      );
    }
    // Call database
  }
}
```

---

## Testing Admin Features

### Unit Tests

```typescript
// Test validation
describe('validateIdeaInput', () => {
  it('should reject empty category', () => {
    const input: AdminIdeaInput = {
      category: '',
      title: 'Test',
      // ...
    }
    const errors = validateIdeaInput(input)
    expect(errors).toHaveLength(1)
    expect(errors[0].field).toBe('category')
  })
})

// Test JSON parsing
describe('parseJSONInput', () => {
  it('should parse valid JSON', () => {
    const json = '{"category":"Psychology","title":"Test",...}'
    const result = parseJSONInput(json)
    expect(result.success).toBe(true)
  })
})
```

### Integration Tests

```typescript
// Test form submission
describe('IdeaForm', () => {
  it('should create idea on submit', async () => {
    const { getByText, getByPlaceholderText } = render(<IdeaForm />)
    
    fireEvent.change(getByPlaceholderText('Title'), {
      target: { value: 'Test Idea' },
    })
    
    fireEvent.click(getByText('Publish Now'))
    
    await waitFor(() => {
      expect(getByText(/published successfully/i)).toBeInTheDocument()
    })
  })
})
```

---

## Troubleshooting

### Issue: Admin Dashboard Not Visible

**Solution**: Check role assignment
```typescript
// In browser console
localStorage.getItem('isAdmin') // Should return 'true'

// Or check with service
import { isCurrentUserAdmin } from '@/lib/services/admin_service'
console.log(isCurrentUserAdmin()) // Should log true
```

### Issue: Validation Errors on Submit

**Solution**: Check field requirements
- All required fields must have values
- Follow character limits and formats
- Use correct category from predefined list
- Status must be 'draft' or 'published'

### Issue: JSON Mode Parse Error

**Solution**: Validate JSON syntax
```javascript
// Test in browser console
JSON.parse('{"category":"Test","title":"Title",...}')
```

---

## Changelog

- **v1.0** (March 13, 2026): Initial release with form and JSON modes, role-based access
- **Upcoming**: Database integration, real persistence, approval workflow

---

## Support

For issues or questions:
1. Check the troubleshooting section above
2. Review the Flutter Migration Guide for cross-platform questions
3. Check ARCHITECTURE.md for system design details

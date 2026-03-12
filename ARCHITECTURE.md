# Application Architecture

## Overview

This application follows a **layered architecture pattern** designed for maintainability, testability, and cross-platform portability (React → Flutter).

## Architecture Layers

```
┌─────────────────────────────────────────────┐
│            UI Layer (React)                  │
│   app/page.tsx, components/*.tsx             │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│       State Management Layer (Hooks)         │
│   useState, useEffect, useContext            │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│       Business Logic Layer (Services)        │
│   lib/services/content_service.ts            │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      Data Access Layer (Repository)          │
│   lib/repositories/content_repository.ts     │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│        Data Layer (Models & Constants)       │
│   lib/models/, lib/constants/                │
└──────────────────┬──────────────────────────┘
                   │
┌──────────────────▼──────────────────────────┐
│      Utility Layer (Helpers & Utils)         │
│   lib/utils/helpers.ts                       │
└─────────────────────────────────────────────┘
```

## Directory Structure

```
project/
├── app/
│   ├── layout.tsx              # Root layout with providers
│   └── page.tsx                # Main application page
├── components/
│   ├── content-card.tsx        # Individual article card
│   ├── expanded-modal.tsx      # Expanded view modal
│   ├── fullscreen-content.tsx  # Full-screen reading view
│   ├── profile-menu.tsx        # Profile dropdown menu
│   ├── theme-provider.tsx      # Theme provider wrapper
│   └── ui/                     # Reusable UI components
├── lib/
│   ├── constants/
│   │   └── app_constants.ts    # Colors, typography, spacing
│   ├── models/
│   │   └── content_model.ts    # Data interfaces & enums
│   ├── services/
│   │   └── content_service.ts  # Business logic
│   ├── repositories/
│   │   └── content_repository.ts # Data access
│   └── utils/
│       └── helpers.ts          # Utility functions
├── public/                     # Static assets
├── ARCHITECTURE.md             # This file
├── FLUTTER_MIGRATION_GUIDE.md  # Flutter conversion guide
└── README.md                   # Project documentation
```

## Data Models

### Core Models (`lib/models/content_model.ts`)

```typescript
interface ContentItem {
  id: number;
  category: string;
  headline: string;
  content: string;
  expandedContent: string;
  saved: boolean;
  liked: boolean;
  shared: boolean;
  likeCount: number;
  saveCount: number;
}

interface UserProfile {
  id: string;
  name: string;
  email: string;
  avatar?: string;
  streakCount: number;
}
```

## Business Logic

### Services (`lib/services/content_service.ts`)

Handles all business logic operations:

- `toggleLike(item)` - Handle like action with count update
- `toggleSave(item)` - Handle save action with count update
- `updateContentEngagement()` - Update multiple engagement states
- `filterByCategory()` - Filter content by category
- `sortByEngagement()` - Sort content by likes/saves
- `getEngagementMetrics()` - Calculate engagement statistics

**Key Design**: Static methods for pure functions, no side effects.

## Data Access

### Repository (`lib/repositories/content_repository.ts`)

Handles all data operations:

- `getAllContent()` - Fetch all articles
- `getContentById()` - Get single article
- `getContentByCategory()` - Filter articles
- `updateContent()` - Persist changes
- `saveEngagement()` - Save user engagement
- `getSavedContent()` - Get user's saved articles
- `getLikedContent()` - Get user's liked articles

**Key Design**: Abstracts data source (API, database, mock data). Currently uses mock data.

## Utilities

### Helpers (`lib/utils/helpers.ts`)

Reusable utility functions:

- `formatNumber()` - Format numbers with K/M notation
- `truncateText()` - Truncate text with ellipsis
- `debounce()` - Debounce function calls
- `throttle()` - Throttle function calls
- `matchesBreakpoint()` - Check responsive breakpoints
- `calculateScrollVelocity()` - Calculate scroll physics
- `handleShare()` - Web Share API wrapper
- `formatDate()` - Date formatting
- `deepClone()` - Deep object cloning

## Component Architecture

### UI Components

All components follow this pattern:

```typescript
interface ComponentProps {
  item: ContentItem;
  onAction: (id: number) => void;
  // ... more props
}

export default function Component({ item, onAction }: ComponentProps) {
  return (
    // JSX
  );
}
```

**Key Principles:**
1. Props over global state for reusability
2. Callback functions for parent communication
3. Pure components where possible
4. TypeScript for type safety

### State Management

Currently uses React hooks:
- `useState` for local component state
- `useEffect` for side effects
- `useTheme` from next-themes for theme management

**Scaling Strategy**:
- For complex state: Consider Context + useReducer
- For global state: Consider Zustand or Jotai

## Constants

### Design Tokens (`lib/constants/app_constants.ts`)

Centralized design values:

```typescript
// Colors (OKLCH)
colors.light / colors.dark

// Typography
typography.fontFamily
typography.fontSize
typography.fontWeight
typography.lineHeight

// Spacing
spacing (0, 1, 2, 4, 6, 8, 12, 16)

// Responsive Breakpoints
breakpoints (mobile: 320px, sm: 640px, md: 768px, lg: 1024px, xl: 1280px)

// UI Constants
ui.navbarHeight
ui.autoScrollDebounce
ui.autoScrollVelocityThreshold
```

## Data Flow

### User Action Flow

```
User clicks "Like" button
    ↓
Component calls onLike(id)
    ↓
page.tsx handleLike() updates state
    ↓
ContentService.toggleLike() processes logic
    ↓
State updated with new like count
    ↓
Component re-renders with new count
    ↓
Repository.saveEngagement() persists to backend (optional)
```

### Navigation Flow

```
User clicks "Focus Mode"
    ↓
page.tsx sets fullscreenIndex & isFullscreenOpen
    ↓
FullscreenContent renders at that index
    ↓
Auto-scroll snaps between articles
    ↓
User presses ESC
    ↓
page.tsx closes fullscreen
```

## Performance Optimizations

### Current Implementation

1. **Memoization**: React memo for card components
2. **Scroll Optimization**: Snap-scroll with debouncing (500ms minimum)
3. **Velocity Detection**: Threshold-based auto-scroll (8px threshold)
4. **Lazy Loading**: Content loaded on demand in modals

### Future Enhancements

1. **Image Optimization**: Next.js Image component
2. **Code Splitting**: Dynamic imports for modals
3. **Virtual Scrolling**: For very long lists
4. **Service Worker**: Offline caching

## Testing Strategy

### Unit Tests
- Services: Test business logic in isolation
- Utilities: Test helper functions
- Models: Test data transformations

### Integration Tests
- Component interactions
- State management flow
- Navigation between screens

### E2E Tests
- Full user flows (like → save → share)
- Error scenarios
- Theme switching

## Error Handling

### Current Approach

1. **Share API**: Try-catch with silent error handling
2. **State Updates**: Defensive checks on toggles
3. **Navigation**: Safe index calculations

### Best Practices

- Never throw unhandled errors
- Log errors for debugging
- Show user-friendly error messages
- Gracefully degrade features

## Security Considerations

### Current Implementation

- No sensitive data stored
- No authentication required (mock user only)
- XSS prevention through React
- CSRF: N/A for read-only operations

### When Adding Real Backend

- Implement JWT authentication
- Validate all inputs server-side
- Use HTTPS only
- Implement rate limiting
- CORS configuration

## Scalability

### Horizontal Scaling

1. **State Management**: Move to Context + Redux if needed
2. **Component Library**: Create shared component package
3. **Monorepo**: Use Nx or Turborepo for multiple apps

### Vertical Scaling

1. **API Caching**: Implement Redis caching
2. **Database Optimization**: Add indexes, optimize queries
3. **CDN**: Serve static assets globally
4. **Lazy Loading**: Load content on-demand

## Deployment

### Current (Development)

```
npm run dev
# Runs on http://localhost:3000
```

### Production

```
npm run build
npm start
# Optimized production build
```

## Monitoring & Logging

### Recommended Tools

1. **Error Tracking**: Sentry
2. **Analytics**: Mixpanel or PostHog
3. **Performance**: Vercel Analytics
4. **Logging**: Winston or Pino

### Key Metrics

- User engagement (likes, saves, shares)
- Streak completion rate
- Content consumption patterns
- Performance metrics (FCP, LCP, CLS)

## Maintenance

### Regular Tasks

- Update dependencies
- Review security advisories
- Monitor error logs
- Analyze user behavior
- A/B testing for UI changes

### Documentation

- Keep README updated
- Document API changes
- Update architecture as it evolves
- Maintain migration guide for Flutter

## Conclusion

This architecture provides a clear separation of concerns, making the codebase:
- **Maintainable**: Each layer has specific responsibilities
- **Testable**: Layers can be tested in isolation
- **Portable**: Easy to migrate to Flutter or other frameworks
- **Scalable**: Can grow with the application
- **Flexible**: Easy to swap implementations (API, database, state management)

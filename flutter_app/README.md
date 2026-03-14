# Think-Thonk UI - Flutter Application

A cross-platform Flutter application that replicates the Think-Thonk web UI exactly, maintaining all functionality, theme, and responsiveness.

## Features

### Authentication
- Login/Register pages with form validation
- Test credentials for immediate testing
- Password visibility toggle
- Session management with persistent state

### Content Feed
- Full-page snap scrolling
- Article cards with category badges
- Like, Save, Share, Focus actions
- Real-time engagement counters
- Auto-hiding navigation bar

### Focus Mode
- Full-screen article reading
- Vertical page-based navigation
- Bottom action bar with streak display
- ESC key to close (on web/desktop)

### Read More Modal
- Expanded content view
- Bullet list parsing
- Sticky header with close button
- Responsive typography

### User Features
- Profile page with stats
- Saved articles with search
- Settings (Theme, Notifications, Privacy)
- Admin dashboard (role-based)

### Theming
- Light/Dark mode support
- System theme detection
- OKLCH-based color palette
- Consistent with web version

## Project Structure

```
flutter_app/
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart    # Design tokens
│   │   └── theme/
│   │       └── app_theme.dart        # Theme configuration
│   ├── models/
│   │   ├── content_model.dart        # Content data models
│   │   └── auth_model.dart           # Auth data models
│   ├── services/
│   │   ├── auth_service.dart         # Authentication logic
│   │   └── content_service.dart      # Content business logic
│   ├── providers/
│   │   ├── theme_provider.dart       # Theme state management
│   │   ├── content_provider.dart     # Content state management
│   │   └── auth_provider.dart        # Auth state management
│   ├── screens/
│   │   ├── home_screen.dart          # Main feed
│   │   ├── auth_screen.dart          # Login/Register
│   │   ├── profile_screen.dart       # User profile
│   │   ├── saved_screen.dart         # Saved articles
│   │   ├── settings_screen.dart      # Settings
│   │   └── admin_screen.dart         # Admin dashboard
│   ├── widgets/
│   │   ├── common/                   # Reusable widgets
│   │   ├── admin/                    # Admin components
│   │   ├── content_card.dart         # Article card
│   │   ├── expanded_modal.dart       # Read more modal
│   │   ├── fullscreen_content.dart   # Focus mode
│   │   └── profile_menu.dart         # Profile dropdown
│   └── main.dart                     # App entry point
├── web/                              # Web platform files
├── android/                          # Android platform files
├── ios/                              # iOS platform files
└── pubspec.yaml                      # Dependencies
```

## Getting Started

### Prerequisites
- Flutter SDK 3.2.0 or higher
- Dart SDK 3.2.0 or higher

### Installation

```bash
# Navigate to flutter_app directory
cd flutter_app

# Get dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on iOS simulator
flutter run -d ios

# Run on Android emulator
flutter run -d android

# Build for production
flutter build web
flutter build apk
flutter build ios
```

## Test Credentials

**Admin Account:**
- Email: admin@thinkthonk.com
- Password: Admin123!@#

**User Account:**
- Email: demo@thinkthonk.com
- Password: Demo123!@#

## Dependencies

- `flutter_riverpod` - State management
- `go_router` - Navigation
- `google_fonts` - Typography
- `shared_preferences` - Local storage
- `share_plus` - Share functionality
- `flutter_animate` - Animations
- `lucide_icons` - Icons

## Design System

### Colors (OKLCH-based)
- Light Background: #FAFAFA
- Dark Background: #0A0A0A
- Primary (Light): #2D2D3A
- Primary (Dark): #FAFAFA
- Like Red: #EF4444
- Streak Orange: #F97316

### Typography
- Font Family: Geist (fallback to system)
- Sizes: 12px - 60px scale
- Weights: 400, 500, 600, 700

### Spacing
- Base unit: 4px
- Scale: 0, 4, 8, 12, 16, 20, 24, 32, 40, 48, 64px

### Breakpoints
- Mobile: < 640px
- Tablet: 640px - 1024px
- Desktop: > 1024px

## Architecture

The app follows a clean architecture pattern:

1. **Models** - Data structures and enums
2. **Services** - Pure business logic functions
3. **Providers** - State management with Riverpod
4. **Widgets** - Reusable UI components
5. **Screens** - Page-level widgets with routing

## Comparison with Web Version

| Feature | Web (Next.js) | Flutter |
|---------|---------------|---------|
| Snap Scroll | CSS snap-y | PageView |
| Theme | next-themes | Riverpod + MaterialApp |
| Navigation | Next.js router | Navigator routes |
| State | useState | Riverpod StateNotifier |
| Styling | Tailwind CSS | Theme + constants |
| Icons | Lucide React | Flutter Icons |

## License

MIT License - see the main project README for details.

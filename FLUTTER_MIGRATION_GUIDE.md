# Flutter Migration Guide

This document provides a comprehensive guide for converting this Next.js/React application to Flutter.

## Project Architecture Overview

The codebase is organized in a **layer-based architecture** that makes it easy to port to Flutter:

```
lib/
├── constants/       # Design tokens, colors, typography, spacing
├── models/         # Data structures and interfaces (Dart classes)
├── services/       # Business logic layer
├── repositories/   # Data access layer (API/Database)
├── utils/          # Helper functions
app/
├── page.tsx        # UI components (will map to Flutter Widgets)
components/
├── *.tsx           # Reusable UI components
```

## Layer-by-Layer Migration

### 1. Constants Layer (`lib/constants/`)

**Current**: TypeScript constants file  
**Flutter Equivalent**: Dart constants class

```dart
// Flutter conversion example
class AppColors {
  static const lightBackground = Color.fromARGB(255, 249, 250, 251);
  static const lightForeground = Color.fromARGB(255, 38, 38, 38);
  // ... more colors
}

class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 16;
  // ... more spacing
}
```

**Files to migrate:**
- `lib/constants/app_constants.ts` → `lib/constants/app_constants.dart`

### 2. Models Layer (`lib/models/`)

**Current**: TypeScript interfaces  
**Flutter Equivalent**: Dart classes with freezed or equatable

```dart
// Flutter conversion using freezed
@freezed
class ContentItem with _$ContentItem {
  const factory ContentItem({
    required int id,
    required String category,
    required String headline,
    required String content,
    required String expandedContent,
    required bool saved,
    required bool liked,
    required bool shared,
    required int likeCount,
    required int saveCount,
  }) = _ContentItem;

  factory ContentItem.fromJson(Map<String, dynamic> json) =>
      _$ContentItemFromJson(json);
}
```

**Files to migrate:**
- `lib/models/content_model.ts` → `lib/models/content_model.dart`

### 3. Services Layer (`lib/services/`)

**Current**: TypeScript class with static methods  
**Flutter Equivalent**: Dart class or Provider/Riverpod service

```dart
class ContentService {
  static ContentItem toggleLike(ContentItem item) {
    return item.copyWith(
      liked: !item.liked,
      likeCount: item.liked ? item.likeCount - 1 : item.likeCount + 1,
    );
  }

  static ContentItem toggleSave(ContentItem item) {
    return item.copyWith(
      saved: !item.saved,
      saveCount: item.saved ? item.saveCount - 1 : item.saveCount + 1,
    );
  }
  // ... more methods
}
```

**Files to migrate:**
- `lib/services/content_service.ts` → `lib/services/content_service.dart`

**Recommended State Management:**
- Use `Riverpod` for service layer (easier than Provider)
- Use `StateNotifier` for complex state

### 4. Repositories Layer (`lib/repositories/`)

**Current**: TypeScript data access class  
**Flutter Equivalent**: Dart repository with Future<> methods

```dart
class ContentRepository {
  static Future<List<ContentItem>> getAllContent() async {
    // Simulate API delay
    await Future.delayed(Duration(milliseconds: 300));
    return mockContent;
  }

  static Future<ContentItem?> getContentById(int id) async {
    await Future.delayed(Duration(milliseconds: 100));
    return mockContent.firstWhereOrNull((item) => item.id == id);
  }
  // ... more methods
}
```

**For API Integration:**
Replace mock data with actual API calls using `dio` or `http` package

### 5. Utils Layer (`lib/utils/`)

**Current**: TypeScript utility functions  
**Flutter Equivalent**: Dart utility functions (can be ported 1:1)

```dart
// String formatting functions
String formatNumber(int num) {
  if (num >= 1000000) {
    return '${(num / 1000000).toStringAsFixed(1)}M';
  }
  if (num >= 1000) {
    return '${(num / 1000).toStringAsFixed(1)}K';
  }
  return num.toString();
}

// Debounce - use Timer or dart_debounce package
// Throttle - use Timer or similar approach
```

**Files to migrate:**
- `lib/utils/helpers.ts` → `lib/utils/helpers.dart`

### 6. UI Components

**Current**: React/Next.js TSX components  
**Flutter Equivalent**: Flutter Widgets (StatelessWidget/StatefulWidget)

**Mapping**:
- React Component → Flutter Widget
- useState → useState from flutter_hooks or Provider
- useEffect → useEffect from flutter_hooks or didChangeDependencies
- Props → Widget constructor parameters
- State → State class or Provider

**Example**:
```dart
// Flutter equivalent of ContentCard
class ContentCard extends StatefulWidget {
  final ContentItem item;
  final VoidCallback onSave;
  final VoidCallback onLike;
  final VoidCallback onShare;
  final VoidCallback onReadMore;
  final VoidCallback onFocus;

  const ContentCard({
    required this.item,
    required this.onSave,
    required this.onLike,
    required this.onShare,
    required this.onReadMore,
    required this.onFocus,
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          // Content
          Text(widget.item.headline),
          // Buttons
          Row(
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.bookmark),
                label: Text('${widget.item.saveCount}'),
                onPressed: widget.onSave,
              ),
              // ... more buttons
            ],
          ),
        ],
      ),
    );
  }
}
```

## Migration Checklist

### Phase 1: Foundation Setup
- [ ] Create Flutter project with `flutter create`
- [ ] Set up directory structure matching TypeScript layout
- [ ] Install necessary packages:
  - [ ] `riverpod` for state management
  - [ ] `freezed` for data classes
  - [ ] `go_router` for routing
  - [ ] `flutter_hooks` for lifecycle management

### Phase 2: Core Layers (No UI)
- [ ] Migrate `lib/constants/` → All constants
- [ ] Migrate `lib/models/` → All data models with freezed
- [ ] Migrate `lib/services/` → All business logic
- [ ] Migrate `lib/repositories/` → All data access (keep mock data initially)
- [ ] Migrate `lib/utils/` → All helper functions
- [ ] Create unit tests for each layer

### Phase 3: UI Components
- [ ] Create app theme (`ThemeData`)
- [ ] Migrate ProfileMenu widget
- [ ] Migrate ContentCard widget
- [ ] Migrate ExpandedModal → showModalBottomSheet or Dialog
- [ ] Migrate FullscreenContent → New route/page
- [ ] Implement theme switching (light/dark)
- [ ] Add responsive layout with `LayoutBuilder`

### Phase 4: State Management
- [ ] Create Riverpod providers for content list
- [ ] Create Riverpod providers for engagement state
- [ ] Create Riverpod providers for theme state
- [ ] Create Riverpod providers for user profile
- [ ] Create Riverpod providers for navigation

### Phase 5: Integration
- [ ] Wire up all providers to UI
- [ ] Implement navigation between screens
- [ ] Implement share functionality using `share_plus`
- [ ] Test all user interactions
- [ ] Optimize performance

### Phase 6: Polish
- [ ] Add animations using `flutter_animate`
- [ ] Add haptic feedback
- [ ] Implement native platform-specific features
- [ ] Add analytics
- [ ] Setup app signing and release builds

## Data Flow Architecture (Same in Flutter)

```
UI Layer (Widgets)
    ↓
Riverpod Providers
    ↓
Services Layer (Business Logic)
    ↓
Repositories Layer (Data Access)
    ↓
Data Sources (API/Database/Mock)
```

This architecture makes it easy to test and maintain both versions.

## Key Differences to Watch

### 1. State Management
- **React**: `useState`, `useContext`, `useReducer`
- **Flutter**: `Provider`, `Riverpod`, `GetX`, `BLoC`
- **Recommendation**: Use `Riverpod` for closest mental model match

### 2. Navigation
- **React**: React Router or Next.js routing
- **Flutter**: `go_router` or `Navigator`
- **Recommendation**: Use `go_router` for declarative routing

### 3. Styling
- **React**: CSS/Tailwind classes
- **Flutter**: `ThemeData`, `BoxDecoration`, `TextStyle`
- **Recommendation**: Mirror Tailwind values in Flutter theme

### 4. Lifecycle Management
- **React**: `useEffect` for lifecycle
- **Flutter**: `initState`, `dispose`, or `useEffect` with flutter_hooks
- **Recommendation**: Use `flutter_hooks` for familiar pattern

### 5. Responsive Design
- **React**: Media queries, Tailwind breakpoints
- **Flutter**: `MediaQuery`, `LayoutBuilder`, orientation listeners
- **Recommendation**: Create responsive layout wrappers

## Shared Code Between React and Flutter

These modules can be shared with minimal changes:
- Constants (with minor syntax adjustments)
- Data models (with code generation)
- Business logic (service functions)
- Utility helpers
- Test data

## Performance Considerations

### Optimization Points
1. **Image caching** - Use `CachedNetworkImage` in Flutter
2. **List scrolling** - Use `ListView.builder` for infinite lists
3. **State updates** - Use immutable models to prevent unnecessary rebuilds
4. **Network requests** - Cache responses appropriately

### Benchmark Targets (from current React version)
- Initial load: < 2s
- List scroll FPS: 60fps
- Like/Save toggle: < 100ms

## Testing Strategy

Both versions should have:
- Unit tests for services
- Unit tests for utilities
- Widget tests for UI components
- Integration tests for full flows

### File Structure
```
test/
├── unit/
│   ├── services/
│   ├── utils/
│   └── repositories/
├── widget/
│   └── screens/
└── integration/
    └── app_test.dart
```

## Deployment Considerations

### iOS
- Minimum iOS 11.0+
- App Store release
- Notarization for macOS if applicable

### Android
- Minimum Android API level 21
- Google Play release
- Size optimization (use R8/ProGuard)

## Resources & References

- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod**: https://riverpod.dev
- **Freezed**: https://pub.dev/packages/freezed
- **Go Router**: https://pub.dev/packages/go_router
- **Flutter Best Practices**: https://flutter.dev/docs/testing/best-practices

## Migration Timeline Estimate

- **Phase 1**: 2-3 days
- **Phase 2**: 3-5 days
- **Phase 3**: 5-7 days
- **Phase 4**: 3-5 days
- **Phase 5**: 3-5 days
- **Phase 6**: 3-7 days

**Total**: 3-4 weeks for full production-ready app

## Support & Questions

When migrating:
1. Refer to this guide's layer structure
2. Check Flutter documentation for equivalent features
3. Use the migration checklist to track progress
4. Test incrementally after each phase
5. Keep UI and business logic separated

# Flutter Quick Start Reference

**TL;DR**: This React app is now Flutter-ready. Use this quick guide to get started with Flutter conversion.

## 5-Minute Overview

### What's Ready for Flutter? ✅

```
lib/constants/app_constants.ts  → lib/constants/app_constants.dart
lib/models/content_model.ts     → lib/models/content_model.dart (Freezed)
lib/services/content_service.ts → lib/services/content_service.dart
lib/repositories/content_repository.ts → lib/providers/content_provider.dart (Riverpod)
lib/utils/helpers.ts            → lib/utils/helpers.dart
```

**No React dependencies!** All core logic is pure and portable.

## Step-by-Step Quick Start

### 1. Create Flutter Project (2 minutes)

```bash
flutter create think_thonk
cd think_thonk
```

### 2. Add Dependencies (1 minute)

Edit `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  riverpod: ^2.0.0
  freezed_annotation: ^2.0.0
  go_router: ^10.0.0
  flutter_hooks: ^0.18.0
  share_plus: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.0.0
  freezed: ^2.0.0
```

Then run:
```bash
flutter pub get
```

### 3. Copy `lib/constants/app_constants.dart`

**Easiest step**: Just copy the constants file and change `.ts` to `.dart`

```dart
// lib/constants/app_constants.dart
const Map<String, dynamic> colors = {
  'light': {
    'background': Color(0xFFFAFAFA),
    'foreground': Color(0xFF262626),
    // ... more colors
  },
};
```

### 4. Create Data Models

Convert interfaces to Freezed classes:

```dart
// lib/models/content_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'content_model.freezed.dart';
part 'content_model.g.dart';

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

Generate code:
```bash
flutter pub run build_runner build
```

### 5. Create Services

Services are 1:1 from React:

```dart
// lib/services/content_service.dart
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

### 6. Create Providers (Riverpod)

Convert repository methods to providers:

```dart
// lib/providers/content_provider.dart
import 'package:riverpod/riverpod.dart';

final contentProvider = FutureProvider<List<ContentItem>>((ref) async {
  return ContentRepository.getAllContent();
});

final contentByIdProvider = FutureProvider.family<ContentItem?, int>((ref, id) async {
  return ContentRepository.getContentById(id);
});

final engagementProvider = StateNotifierProvider<EngagementNotifier, Map<int, UserEngagement>>((ref) {
  return EngagementNotifier();
});
```

### 7. Create First Widget

Start simple:

```dart
// lib/screens/content_feed.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContentFeedScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(contentProvider);

    return content.when(
      data: (items) => ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ContentCard(item: items[index]);
        },
      ),
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

class ContentCard extends StatelessWidget {
  final ContentItem item;

  const ContentCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.category, style: TextStyle(fontSize: 12, color: Colors.grey)),
            SizedBox(height: 8),
            Text(item.headline, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(item.content),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(children: [
                  Icon(Icons.bookmark),
                  Text(formatNumber(item.saveCount)),
                ]),
                Column(children: [
                  Icon(Icons.favorite),
                  Text(formatNumber(item.likeCount)),
                ]),
                Column(children: [
                  Icon(Icons.share),
                  Text('Share'),
                ]),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### 8. Set Up Navigation

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: GoRouter(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => ContentFeedScreen(),
          ),
          GoRoute(
            path: '/focus/:id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return FocusModeScreen(contentId: id);
            },
          ),
        ],
      ),
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
    );
  }
}
```

### 9. Implement Share

```dart
// Replace handleShare from utils
import 'package:share_plus/share_plus.dart';

Future<void> shareContent(String title, String text) async {
  try {
    await Share.share('$title\n\n$text');
  } catch (e) {
    print('Share error: $e');
  }
}
```

### 10. Run It! 🚀

```bash
flutter run
```

## Key Differences: React → Flutter

| React | Flutter | Notes |
|-------|---------|-------|
| `useState` | `StateNotifier` / `Riverpod` | Use Riverpod for cleaner code |
| `useEffect` | `useEffect` (flutter_hooks) | Or `didChangeDependencies` |
| CSS/Tailwind | `ThemeData` / `BoxDecoration` | Define in constants |
| Components | Widgets | StatelessWidget or StatefulWidget |
| Props | Constructor parameters | Same concept |
| State | Riverpod providers | Replaces Context |
| Navigation | go_router | Matches Next.js routing feel |

## File Conversion Rules

### Constants
```typescript
// React
export const NAVBAR_HEIGHT = 64;

// Flutter
const double NAVBAR_HEIGHT = 64;
```

### Models
```typescript
// React
interface ContentItem {
  id: number;
  title: string;
}

// Flutter (with Freezed)
@freezed
class ContentItem with _$ContentItem {
  const factory ContentItem({
    required int id,
    required String title,
  }) = _ContentItem;
}
```

### Services
```typescript
// React
static toggleLike(item: ContentItem): ContentItem {
  return { ...item, liked: !item.liked };
}

// Flutter
static ContentItem toggleLike(ContentItem item) {
  return item.copyWith(liked: !item.liked);
}
```

### Utils (Promises → Futures)
```typescript
// React
static async toggleLike(id: number): Promise<boolean> {
  return true;
}

// Flutter
static Future<bool> toggleLike(int id) async {
  return true;
}
```

## Testing Quick Example

```dart
// test/services/content_service_test.dart
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ContentService', () {
    test('toggleLike increments count', () {
      final item = ContentItem(
        id: 1,
        liked: false,
        likeCount: 10,
        // ... other fields
      );

      final result = ContentService.toggleLike(item);

      expect(result.liked, true);
      expect(result.likeCount, 11);
    });

    test('toggleLike decrements count when already liked', () {
      final item = ContentItem(
        id: 1,
        liked: true,
        likeCount: 10,
        // ... other fields
      );

      final result = ContentService.toggleLike(item);

      expect(result.liked, false);
      expect(result.likeCount, 9);
    });
  });
}
```

Run tests:
```bash
flutter test
```

## Performance Tips

1. **Use `const` widgets** - Prevent unnecessary rebuilds
2. **Lazy load lists** - Use `ListView.builder` not `Column`
3. **Avoid `FutureBuilder`** - Use Riverpod instead
4. **Profile performance** - Use DevTools
5. **Cache images** - Use `CachedNetworkImage` package

## Common Packages You'll Need

```yaml
dependencies:
  riverpod: ^2.0.0              # State management
  freezed_annotation: ^2.0.0    # Data classes
  go_router: ^10.0.0            # Navigation
  flutter_hooks: ^0.18.0        # React-like hooks
  share_plus: ^6.0.0            # Share functionality
  cached_network_image: ^3.2.0  # Image caching
  flutter_animate: ^4.0.0       # Animations
  intl: ^0.18.0                 # Internationalization

dev_dependencies:
  build_runner: ^2.0.0          # Code generation
  freezed: ^2.0.0               # Freezed generator
```

## Helpful Commands

```bash
# Create new project
flutter create app_name

# Run app
flutter run

# Run with verbose output
flutter run -v

# Run tests
flutter test

# Generate code
flutter pub run build_runner build

# Watch for changes
flutter pub run build_runner watch

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ipa --release

# Check app size
flutter build appbundle --analyze-size

# Profile app
flutter run --profile

# Get diagnostics
flutter doctor

# Upgrade Flutter
flutter upgrade
```

## Documentation Links

- [Flutter Docs](https://flutter.dev/docs)
- [Riverpod Docs](https://riverpod.dev)
- [Go Router](https://pub.dev/packages/go_router)
- [Freezed](https://pub.dev/packages/freezed)
- [Flutter Hooks](https://pub.dev/packages/flutter_hooks)

## Estimated Timeline

- Day 1: Setup + Constants + Models
- Day 2: Services + Providers
- Day 3: First screens
- Day 4-5: Integration + Navigation
- Day 6-7: Polish + Testing

**Total: 1 week** for basic version, **3-4 weeks** for feature-complete production app.

## Next Steps

1. ✅ Read this file
2. 📖 Read `FLUTTER_MIGRATION_GUIDE.md` for details
3. 📐 Study `ARCHITECTURE.md` for design patterns
4. 💻 Create Flutter project
5. 🔄 Start with Phase 1 (foundation)
6. ✅ Follow migration checklist
7. 🚀 Deploy!

---

**Ready to build for Flutter?** Let's go! 🚀

# Think-Thonk Flutter App

A Flutter replica of the Think-Thonk Next.js web application.  
Runs on **Web**, **Android**, and **iOS**.

---

## Project Structure

```
flutter_app/
├── lib/
│   ├── core/
│   │   ├── constants/       # app-level colors, spacing, typography
│   │   └── theme/           # Material 3 light/dark ThemeData
│   ├── features/
│   │   ├── feed/            # main feed: models, repository, controller, screens, widgets
│   │   │   ├── models/      # Idea domain model
│   │   │   ├── repositories/# FeedRepository (local mock → Firestore)
│   │   │   ├── controllers/ # FeedController (Riverpod)
│   │   │   ├── screens/     # HomeScreen
│   │   │   └── widgets/     # ContentCard, ExpandedModal, FullscreenContent, ProfileMenu
│   │   ├── categories/      # category browsing UI
│   │   │   └── screens/     # CategoriesScreen
│   │   ├── interactions/    # likes and saves
│   │   │   ├── models/      # InteractionState
│   │   │   ├── repositories/# InteractionRepository
│   │   │   └── controllers/ # InteractionController
│   │   ├── saved/           # saved articles
│   │   │   ├── models/      # SavedArticle
│   │   │   ├── repositories/# SavedRepository
│   │   │   ├── controllers/ # SavedController
│   │   │   └── screens/     # SavedScreen
│   │   ├── share/           # share flow
│   │   │   └── controllers/ # ShareController
│   │   ├── streak/          # user streak
│   │   │   ├── models/      # StreakModel
│   │   │   ├── repositories/# StreakRepository
│   │   │   └── controllers/ # StreakController
│   │   ├── auth/            # authentication
│   │   │   ├── models/      # AppUser, AuthSession, AuthResponse
│   │   │   ├── repositories/# AuthRepository
│   │   │   ├── controllers/ # AuthController + ThemeController
│   │   │   └── screens/     # AuthScreen, ProfileScreen
│   │   ├── admin/           # admin dashboard
│   │   │   ├── models/      # AdminIdea
│   │   │   ├── controllers/ # AdminController
│   │   │   ├── screens/     # AdminScreen
│   │   │   └── widgets/     # AdminPanel, IdeaForm
│   │   ├── settings/        # app settings
│   │   │   ├── controllers/ # SettingsController
│   │   │   └── screens/     # SettingsScreen
│   │   └── shared/
│   │       └── widgets/     # ActionButton, CategoryBadge, AppInput, AppSwitch, SettingToggle
│   ├── services/            # (reserved for Firebase service bootstrap)
│   ├── app.dart             # MaterialApp router + shell
│   └── main.dart            # entry point
├── android/
├── ios/
├── web/
├── test/
├── FIREBASE_SETUP.md
└── README.md
```

---

## Getting Started

### Prerequisites

- Flutter SDK ≥ 3.10
- Dart SDK ≥ 3.0

### Running the App

```bash
cd flutter_app

# Install dependencies
flutter pub get

# Run on web
flutter run -d chrome

# Run on Android (emulator or device)
flutter run -d android

# Run on iOS (macOS only)
flutter run -d ios
```

---

## Features

| Feature | Description |
|---------|-------------|
| **Feed** | Vertical snap-scroll content cards with auto-hiding navbar |
| **Fullscreen / Focus** | Full-page reading mode with bottom action bar |
| **Expanded Modal** | Overlay with parsed paragraphs and bullet points |
| **Like / Save / Share** | Per-item engagement with live counters |
| **Streak** | Daily reading streak with fire icon |
| **Auth** | Login + Registration with hardcoded test users |
| **Profile** | View/edit user profile with stats |
| **Saved Articles** | Searchable list of saved items |
| **Categories** | Browse ideas grouped by topic |
| **Settings** | Theme toggle, notifications, privacy |
| **Admin** | Create/publish ideas with field or JSON input (admin users only) |
| **Dark Mode** | Full light/dark/system theme support |

---

## Test Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | `admin@thinkthonk.com` | `Admin123!@#` |
| User | `demo@thinkthonk.com` | `Demo123!@#` |

---

## Firebase Integration

See [FIREBASE_SETUP.md](./FIREBASE_SETUP.md) for instructions on connecting to Firestore,
Firebase Auth, and Cloud Functions.

---

## Tech Stack

- **Flutter** + **Dart**
- **flutter_riverpod** – state management
- **google_fonts** – Inter typography
- **shared_preferences** – local session persistence
- **share_plus** – native share sheet
- **flutter_animate** – micro-animations

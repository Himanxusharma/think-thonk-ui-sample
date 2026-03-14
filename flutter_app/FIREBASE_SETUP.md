# FIREBASE_SETUP.md

## Firebase Setup for Think-Thonk Flutter App

This document describes how to connect the app to Firebase for production data.

---

## Current State

The app is fully functional with **local mock data** (no Firebase needed to run).  
All seed content, authentication, interactions, and streaks are in-memory.

---

## Steps to Enable Firebase

### 1. Create a Firebase Project

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create a new project: **think-thonk**
3. Enable **Google Analytics** (optional)

### 2. Register Your Apps

Register **Android**, **iOS**, and **Web** apps within the Firebase console.

### 3. Install FlutterFire CLI

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This generates `lib/firebase_options.dart`.

### 4. Add Firebase Packages

```yaml
dependencies:
  firebase_core: ^3.x.x
  cloud_firestore: ^5.x.x
  firebase_auth: ^5.x.x
  firebase_storage: ^12.x.x
  cloud_functions: ^5.x.x
```

### 5. Initialize Firebase in `main.dart`

```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ProviderScope(child: ThinkThonkApp()));
}
```

---

## Firestore Collections

| Collection | Documents | Notes |
|------------|-----------|-------|
| `ideas` | `{id}` | Published ideas (feed content) |
| `users` | `{uid}` | User profiles |
| `interactions/{uid}/likes` | `{ideaId}` | Per-user likes |
| `interactions/{uid}/saves` | `{ideaId}` | Per-user saves |
| `streaks` | `{uid}` | User streak data |

### Idea Document Schema

```json
{
  "id": "string",
  "category": "string",
  "headline": "string",
  "content": "string",
  "expandedContent": "string",
  "likeCount": 0,
  "saveCount": 0,
  "shareCount": 0,
  "createdAt": "timestamp",
  "publishedAt": "timestamp",
  "createdBy": "uid"
}
```

---

## Replacing Repositories

Each feature has a `repository/` folder. Swap the local implementation for a Firestore one:

- `FeedRepository` → query `ideas` collection ordered by `publishedAt`
- `InteractionRepository` → write to `interactions/{uid}/likes|saves`
- `StreakRepository` → read/write `streaks/{uid}`
- `SavedRepository` → query `interactions/{uid}/saves`
- `AuthRepository` → replace with `FirebaseAuth` calls

---

## Cloud Functions (functions/ folder)

Create a `functions/` directory at the project root for:

- `onIdeaPublished` – sends push notifications
- `aggregateLikes` – updates denormalized counters
- `migrateContent` – seed migration scripts

---

## Security Rules (Firestore)

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /ideas/{id} {
      allow read: if true;
      allow write: if request.auth.token.role == 'admin';
    }
    match /interactions/{uid}/{col}/{docId} {
      allow read, write: if request.auth.uid == uid;
    }
    match /streaks/{uid} {
      allow read, write: if request.auth.uid == uid;
    }
    match /users/{uid} {
      allow read: if true;
      allow write: if request.auth.uid == uid;
    }
  }
}
```

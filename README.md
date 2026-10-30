# Gebetsglas 🫙

> Prayer-jar app: collect prayer requests in categories, draw one at random like notes
> from a glass jar, get reminded daily, and keep a prayer journal. 100% on-device.

Gebetsglas ("prayer jar") is a Flutter app that brings the old prayer-jar habit to
your phone. You drop requests into thematic categories, let the app draw a random
one for you, log your prayers in a journal, and get a daily push reminder.

## Features

- **Categories & requests** – create, edit, and delete prayer categories and requests
- **Draw from the jar** 🎴 – pull a random request from all categories or a single one
- **Prayer journal** – every "I prayed" is logged with a timestamp; entries are
  grouped by day, with a streak counter (consecutive days with at least one prayer)
- **Daily reminder** – schedule a local push notification at a time of your choice,
  with one random request per selected category (Android 13+ permission handling,
  rescheduled on app start)
- **Modern Material 3 UI** – light & dark mode, custom Gebetsglas app icon
  (adaptive + legacy launcher icons)
- **Privacy first** – SQLite database and local notifications only. No account,
  no server, no tracking, no backend.

## Tech stack

| Layer           | Choice |
|-----------------|--------|
| UI              | Flutter (Material 3, `ColorScheme.fromSeed`) |
| Storage         | `sqflite` (local SQLite, foreign keys ON) |
| Notifications   | `flutter_local_notifications` + `timezone` / `flutter_timezone` |
| Settings        | `shared_preferences` |

## Project structure

```
lib/
├── main.dart                  # App entry, theme, root navigation
├── models/                    # Category, PrayerRequest, JournalEntry
├── db/database.dart           # SQLite schema + queries (draw, journal, streak)
├── services/
│   ├── notification_service.dart  # Daily scheduled push notification
│   └── settings_service.dart      # Notification prefs via SharedPreferences
├── screens/
│   ├── home_screen.dart       # Overview: stats, streak, recent prayers
│   ├── categories_screen.dart # Category list + CRUD
│   ├── requests_screen.dart   # Prayer requests + "prayed" action
│   ├── draw_screen.dart       # The jar: random draw experience
│   ├── journal_screen.dart    # Prayer journal grouped by day
│   └── settings_screen.dart   # Notification settings
└── widgets/                   # GlassCard, EmptyState, helpers
```

## Getting started

```bash
# Prerequisites: Flutter stable, Android SDK (for Android builds)
flutter pub get
flutter run          # on a connected device/emulator
```

Checks and build:

```bash
flutter analyze      # static analysis (0 issues expected)
flutter test         # unit + widget tests
flutter build apk --release --split-per-abi   # arm64 / armv7 / x86_64 APKs
```

## CI / builds on GitHub

A GitHub Actions workflow (`.github/workflows/build.yml`) runs on every push and
pull request to `main`:

- Runs `flutter analyze` + `flutter test`
- Builds split-per-abi release APKs (arm64-v8a, armeabi-v7a, x86_64)
- Attaches the APKs as **run artifacts** – every commit push gets fresh builds
- Pushing a tag like `v1.0.0` additionally creates a **GitHub Release** with the
  APKs attached

Local install: download the `app-arm64-v8a-release.apk` (most modern phones),
open it and allow "install unknown apps". The APK is signed with the debug key —
fine for personal use, not for the Play Store.

## Roadmap (not yet implemented)

- Server sync / sharing prayers with friends or a community (explicitly out of
  scope for now)
- Email reminders (the app sends push notifications only)
- iOS build (the code targets Android + iOS; building iOS requires a Mac)

## Development notes

- UI texts are German; code, comments, and commits are English (repo is shareable).
- Local-only by design; the database lives in the app sandbox.

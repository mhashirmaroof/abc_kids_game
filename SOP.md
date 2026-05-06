# 📋 SOP — Standard Operating Procedures
## ABC Kids: Tap & Learn | Developer Guidelines

> This document defines the **rules, workflows, code standards, and conventions**
> that must be followed consistently across the entire project.
> Every AI assistant, collaborator, or contributor MUST read and follow this SOP.

---

## ⚠️ CRITICAL RULES (Must Follow — No Exceptions)

| # | Rule |
|---|---|
| 🔴 1 | **NEVER `git push` without explicit permission from the project owner** |
| 🔴 2 | **NEVER `flutter run` or launch the app without explicit permission** |
| 🔴 3 | **NEVER `flutter build` (APK/IPA) without explicit permission** |
| 🔴 4 | **ALWAYS ask before executing any command that modifies remote state** |
| 🔴 5 | **Code style, naming, and structure MUST be consistent across ALL files** |

### ✅ How to Ask for Permission
Before any of the above restricted actions, always say:
> _"Ready to push. Shall I go ahead?"_
> _"Ready to run on simulator. Shall I go ahead?"_
> _"Ready to build release APK. Shall I go ahead?"_

---

## 📁 PROJECT STRUCTURE

```
abc_kids_game/
├── lib/
│   ├── main.dart                     # App entry point only — no business logic
│   ├── constants/
│   │   └── app_constants.dart        # ALL constants here — colors, strings, AdMob IDs
│   ├── models/
│   │   └── letter_model.dart         # Data models — immutable, fromJson only
│   ├── providers/
│   │   └── app_providers.dart        # ALL Riverpod providers — one file for now
│   ├── services/
│   │   ├── alphabet_service.dart     # JSON loading + caching
│   │   └── audio_service.dart        # TTS + SFX — static methods only
│   └── screens/
│       ├── onboarding_screen.dart
│       ├── home_screen.dart
│       ├── learn_screen.dart
│       ├── play_screen.dart
│       └── trace_screen.dart
├── assets/
│   ├── data/
│   │   └── alphabet.json
│   ├── images/                       # Format: {letter}_{word}.png  e.g. a_apple.png
│   ├── sounds/                       # Format: {name}.wav  e.g. success.wav
│   ├── fonts/                        # Fredoka-Regular.ttf, Fredoka-Bold.ttf
│   └── animations/                   # Lottie JSON files
├── test/
│   └── widget_test.dart
├── SOP.md                            # ← This file
├── MILESTONES.md                     # Phase tracker
├── README.md                         # Public-facing documentation
└── abc_kids_games.md                 # Full PRD
```

---

## 🎨 CODE STYLE STANDARDS

### General Rules
- **Language:** Dart 3.x — use modern syntax (records, patterns, null-safety)
- **Formatter:** `dart format` — always format before committing
- **Linter:** `flutter analyze` must return **zero issues** before any commit
- **Line length:** 100 characters max
- **Indentation:** 2 spaces (Dart default)

---

### Naming Conventions

| Element | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `audio_service.dart` |
| Classes | `PascalCase` | `AudioService`, `LetterModel` |
| Variables | `camelCase` | `currentIndex`, `starCount` |
| Constants | `camelCase` in class | `AppColors.blue`, `AppStrings.appName` |
| Private members | `_camelCase` | `_tts`, `_sfx`, `_currentIndex` |
| Providers | `camelCase` + `Provider` suffix | `alphabetProvider`, `starCountProvider` |
| Screens | `PascalCase` + `Screen` suffix | `LearnScreen`, `PlayScreen` |
| Services | `PascalCase` + `Service` suffix | `AudioService`, `AlphabetService` |
| Asset images | `{letter}_{word}.png` | `a_apple.png`, `z_zebra.png` |
| Asset sounds | `{action}.wav` | `success.wav`, `error.wav` |

---

### File Structure Template (Every Dart File)

```dart
// ── Imports: dart → flutter → packages → local (in this order) ──────────────
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_constants.dart';
import '../models/letter_model.dart';

// ── Class / Widget ────────────────────────────────────────────────────────────
class ExampleScreen extends ConsumerWidget {
  const ExampleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ...
  }
}
```

---

### Widget Rules

| Rule | Detail |
|---|---|
| `const` constructors | Use `const` wherever possible |
| `super.key` | Always pass `{super.key}` in constructors |
| Extract widgets | If a widget block is > 30 lines, extract to a private method or class |
| No hardcoded colors | Always use `AppColors.*` constants |
| No hardcoded strings | Always use `AppStrings.*` constants |
| No hardcoded text styles | Always use `AppFonts.*` styles |
| Button min height | All tappable targets must be ≥ 80px height (PRD UX rule) |
| Rounded corners | All cards/buttons use `BorderRadius.circular(24)` |

---

### State Management Rules (Riverpod)

- All providers live in `lib/providers/app_providers.dart`
- Use `ConsumerWidget` / `ConsumerStatefulWidget` — never `StatefulWidget` for state that belongs in providers
- Provider naming: always suffix with `Provider`
- `FutureProvider` for async data (e.g., JSON loading)
- `StateProvider` for simple mutable state (e.g., index, star count)

```dart
// ✅ Correct
final starCountProvider = StateProvider<int>((ref) => 0);

// ❌ Wrong — don't manage shared state in widget setState
setState(() { _stars++; });
```

---

### Service Rules

- Services are **static-only classes** (no instantiation needed externally)
- `AudioService` — always call `AudioService.init()` in `main.dart` before runApp
- `AlphabetService` — cached after first load, never reload unnecessarily
- Services must **never import screen files**

---

### Asset Rules

| Asset Type | Location | Naming | Format |
|---|---|---|---|
| Letter images | `assets/images/` | `{letter}_{word}.png` | PNG, 200×200px min |
| Sound effects | `assets/sounds/` | `{action}.wav` | WAV (44100Hz, 16-bit mono) |
| Fonts | `assets/fonts/` | `Fredoka-{Weight}.ttf` | TTF |
| Lottie animations | `assets/animations/` | `{name}.json` | Lottie JSON |
| JSON data | `assets/data/` | `{name}.json` | JSON |

> **Note:** Placeholder PNGs and WAV files are currently in place. Replace with
> real CC0-licensed assets before release. See `MILESTONES.md` Phase 3.

---

## 🌿 GIT WORKFLOW

### Branch Strategy
```
main          ← production-ready code only
feature/*     ← new features  e.g. feature/trace-mode-waypoints
fix/*         ← bug fixes     e.g. fix/audio-crash-ios
chore/*       ← non-code work e.g. chore/update-readme
```

### Commit Message Format (Conventional Commits)
```
<type>(<scope>): <short description>

[optional body]
```

| Type | When to use |
|---|---|
| `feat` | New feature added |
| `fix` | Bug fixed |
| `chore` | Maintenance, config, docs |
| `style` | Formatting, no logic change |
| `refactor` | Code restructure, no feature change |
| `test` | Adding or fixing tests |
| `assets` | Adding/updating asset files |

**Examples:**
```
feat(play-screen): add confetti on 5-star milestone
fix(audio): update SFX paths from .mp3 to .wav
chore(deps): upgrade audioplayers to 6.1.0
assets(images): add 26 placeholder letter PNGs
```

### Pre-Commit Checklist (ALWAYS do before committing)
- [ ] `flutter analyze` → zero issues
- [ ] `dart format lib/` → code formatted
- [ ] Manually tested the changed screen(s)
- [ ] No hardcoded test IDs, secrets, or API keys committed

### Pre-Push Checklist (ALWAYS ask owner first)
- [ ] Owner has given explicit push approval
- [ ] All pre-commit checks passed
- [ ] Commit message follows format above

---

## 🚀 RUN / BUILD COMMANDS (Permission Required Before Use)

| Command | Purpose | Permission Required |
|---|---|---|
| `flutter run` | Run in debug mode on device/simulator | ✅ Ask first |
| `flutter run --release` | Run in release mode | ✅ Ask first |
| `flutter build apk` | Build Android APK | ✅ Ask first |
| `flutter build appbundle` | Build Android AAB for Play Store | ✅ Ask first |
| `flutter build ipa` | Build iOS IPA for App Store | ✅ Ask first |
| `git push origin main` | Push to GitHub | ✅ Ask first |
| `flutter pub upgrade` | Upgrade all packages | ✅ Ask first |

**Safe to run anytime (no permission needed):**
```bash
flutter analyze           # Static analysis
flutter test              # Unit/widget tests
dart format lib/          # Format code
flutter pub get           # Install packages (after pubspec.yaml change)
flutter clean             # Clean build cache
git status / git log      # Read-only git commands
```

---

## 🔐 SECRETS & SECURITY

- **NEVER commit** `keystore.jks`, `key.properties`, `GoogleService-Info.plist`, `google-services.json`
- AdMob IDs in `app_constants.dart` are currently **TEST IDs** — replace before release
- Real AdMob IDs are managed by the project owner only
- All of the above are covered in `.gitignore`

---

## 📱 PLATFORM NOTES

### Android
- Min SDK: 21 (Android 5.0)
- Target SDK: 34
- Package: `com.hashirmaroof.abc_kids_game`
- Child-directed AdMob: `tagForChildDirectedTreatment: yes`

### iOS
- Min iOS: 12.0
- Bundle ID: `com.hashirmaroof.abc_kids_game`
- Child-directed AdMob: `tagForChildDirectedTreatment: yes`, `tagForUnderAgeOfConsent: yes`

---

## 🧪 TESTING STANDARDS

- Every new screen gets at least **1 widget test** in `test/widget_test.dart`
- Tests must import real screens — no boilerplate counter tests
- Test naming: `'ScreenName renders correctly'`, `'ScreenName navigates to X on tap'`
- Run `flutter test` before every release build

---

## 📝 DOCUMENTATION RULES

| File | Purpose | Update When |
|---|---|---|
| `SOP.md` | Rules & standards | Standards or workflow changes |
| `MILESTONES.md` | Phase & task tracker | **After every task completed or blocked** |
| `README.md` | Public project overview | Major features added or released |
| `abc_kids_games.md` | Full PRD | Product decisions change |

### MILESTONES.md — Mandatory Update Rules

> `MILESTONES.md` is a **living document**. It must always reflect the true state of the project.

**When to update MILESTONES.md:**
- ✅ A task is completed → change `⏳ Pending` to `✅ Done` + add a note
- 🔁 A task is blocked → change status to `🔁 In Loop` + add to the Blockers table
- 🔄 Work starts on a task → change to `🔄 In Progress`
- ❌ A task is cancelled → change to `❌ Cancelled` + note why

**What to update every session:**
1. The specific **task row** — status + notes column
2. **Overall Project Status** table at the top if an area changes
3. **Known Blockers** table — add new ones, strikethrough resolved ones
4. **Progress bars** in the `📊 Progress Summary` section
5. The **`Last Updated` date** at the top of the file
6. **Immediate Next Actions** — remove done items, add new ones

**Progress bar format:**
```
Phase N — Name    ██████████  100% (note)   ← complete
Phase N — Name    ████████░░   80% (note)   ← in progress
Phase N — Name    ░░░░░░░░░░    0% (note)   ← not started
```
Each `█` = 10%. Count completed tasks ÷ total tasks per phase to calculate %.

---

*Last Updated: May 6, 2026 | Owner: @mhashirmaroof*

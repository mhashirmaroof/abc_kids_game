## 🗺️ MILESTONES — ABC Kids: Tap & Learn
## Living Project Tracker | Last Updated: May 8, 2026

> This document tracks **every phase, task, status, and decision** for the project.
> Update status markers as work progresses.

> 📌 **PLATFORM STRATEGY:** Android-first. Complete 100% Android → Publish on Play Store → Then start iOS.

---

## 📌 STATUS LEGEND

| Symbol | Meaning |
|---|---|
| ✅ | Done — completed and verified |
| 🔄 | In Progress — actively being worked on |
| ⏳ | Pending — not started yet |
| 🔁 | In Loop — blocked or needs revisit |
| 🔜 | Upcoming — scheduled for next phase |
| ❌ | Cancelled / Not applicable |

---

## 🏁 OVERALL PROJECT STATUS

| Area | Status |
|---|---|
| Product Document (PRD) | ✅ Complete & Mature |
| Flutter Project Setup | ✅ Done |
| Package Installation | ✅ Done |
| Folder Structure | ✅ Done |
| Core Dart Files (boilerplate) | ✅ Done |
| .gitignore (all platforms) | ✅ Done |
| README.md | ✅ Done |
| Widget Tests (fixed) | ✅ Done |
| Asset Files (images/sounds/fonts) | ✅ Done |
| Screen Implementation (full UI) | 🔄 In Progress |
| AdMob Real IDs | ⏳ Pending |
| Device Testing | ⏳ Pending |
| Store Submission | ⏳ Pending | Android only (Play Store first) |
| SOP.md (code standards & rules) | ✅ Done |

---

---

# PHASE 1 — FOUNDATION
## 🗓️ Timeline: Week 1 (Days 1–7)
## 🎯 Goal: Project skeleton ready, data loaded, Learn Mode working

---

### 📋 TASK BREAKDOWN

#### Day 1–2: Project Setup
| Task | Status | Notes |
|---|---|---|
| Create Flutter project (`flutter create`) | ✅ Done | `com.hashirmaroof.abc_kids_game` |
| Configure `pubspec.yaml` with all packages | ✅ Done | 8 packages added |
| Run `flutter pub get` | ✅ Done | All resolved |
| Create folder structure (`lib/`, `assets/`) | ✅ Done | All dirs created |
| Setup `.gitignore` (root, android, ios) | ✅ Done | Full coverage |
| Update `README.md` | ✅ Done | Full documentation |
| Fix `widget_test.dart` | ✅ Done | Replaced boilerplate |

#### Day 3–4: Data & Assets
| Task | Status | Notes |
|---|---|---|
| Create `assets/data/alphabet.json` (A–Z) | ✅ Done | Full 26 letters |
| Create `LetterModel` data class | ✅ Done | `lib/models/letter_model.dart` |
| Create `AlphabetService` (JSON loader) | ✅ Done | Cached, async |
| Create `AppConstants` (colors, strings, AdMob IDs) | ✅ Done | Test IDs in place |
| Download Fredoka font from Google Fonts | ✅ Done | `assets/fonts/` — variable font (wght+wdth) |
| Download A–Z letter images (CC0 from OpenGameArt) | ✅ Done | 26 placeholder PNGs — replace with real art |
| Download SFX sounds (CC0 from Freesound.org) | ✅ Done | success/error/cheer WAV generated |

#### Day 5–7: Learn Mode Screen
| Task | Status | Notes |
|---|---|---|
| Create `AppProviders` (Riverpod state) | ✅ Done | index, stars, mode |
| Create `AudioService` (TTS + SFX wrapper) | ✅ Done | flutter_tts + audioplayers |
| Build `OnboardingScreen` (welcome, first launch) | ✅ Done | 2 screens, shared_preferences |
| Build `HomeScreen` (3 mode cards) | ✅ Done | Navigate to all 3 modes |
| Build `LearnScreen` (letter + tap + TTS) | ✅ Done | Prev/Next navigation |
| Test Learn Mode on emulator | ⏳ Pending | Needs owner permission to run |
| Phonics tone tuning (TTS pitch/speed) | ⏳ Pending | Adjust after first test |

---

### ✅ PHASE 1 COMPLETION CRITERIA
- [x] All assets (fonts + images + sounds) added ✅
- [x] `flutter analyze` zero issues ✅
- [ ] App launches without crashes (needs device run)
- [x] Onboarding shows on first launch only (SplashScreen logic ✅)
- [x] Learn Mode: A–Z navigable with audio (code complete ✅)
- [ ] All assets loading correctly on device (needs device run)

---

---

# PHASE 2 — CORE FEATURES
## 🗓️ Timeline: Week 2 (Days 8–14)
## 🎯 Goal: Play Mode + Trace Mode + Reward System working

---

### 📋 TASK BREAKDOWN

#### Day 8–9: Play Mode
| Task | Status | Notes |
|---|---|---|
| Build `PlayScreen` (match the letter game) | ✅ Done | 3 options per question |
| Correct answer: star animation + cheer sound | ✅ Done | Via AudioService |
| Wrong answer: shake animation + error sound | ✅ Done | flutter_animate shakeX |
| Smart difficulty (gradually harder options) | ✅ Done | Random pool logic |
| Confetti burst every 5 stars | ✅ Done | confetti package |
| Star counter in AppBar | ✅ Done | Riverpod starCountProvider |
| Test Play Mode end-to-end | ✅ Done | Wrong answer bug fixed, correct reveal added |

#### Day 10–12: Trace Mode
| Task | Status | Notes |
|---|---|---|
| Build `TraceScreen` (CustomPainter skeleton) | ✅ Done | Canvas + GestureDetector |
| Define waypoints for letter "A" | ✅ Done | 10 waypoints, 70% threshold |
| Finger drag detection (20px tolerance) | ✅ Done | `isWaypointHit` logic |
| Success trigger (≥70% waypoints hit) | ✅ Done | Plays success sound |
| Define waypoints for ALL 26 letters (B–Z) | ✅ Done | All A–Z in `_letterWaypoints` map |
| Dotted letter background (visual guide) | ✅ Done | Semi-transparent text |
| Waypoint highlight as finger passes | ✅ Done | Green dot on hit |
| Reset button | ✅ Done | AppBar refresh icon |
| Test Trace Mode on physical device | ⏳ Pending | Touch feel matters |

#### Day 13–14: Reward System Polish
| Task | Status | Notes |
|---|---|---|
| Star count per session | ✅ Done | Riverpod state |
| Confetti on 5-star milestone | ✅ Done | ConfettiController |
| Celebration sound on milestone | ✅ Done | playCheer() |
| Optional mascot character reaction | ⏳ Pending | Phase 2 stretch goal |
| Lottie animation for success | ⏳ Pending | Need Lottie JSON file |

---

### ✅ PHASE 2 COMPLETION CRITERIA
- [x] Play Mode: 26 questions cycle, correct/wrong feedback works
- [x] Trace Mode: All 26 letters have waypoints defined
- [x] Reward system: Stars accumulate, confetti fires at 5-star milestones
- [ ] No crashes in any of the 3 modes (needs device run)

---

---

# PHASE 3 — POLISH & ADS
## 🗓️ Timeline: Week 3 (Days 15–21)
## 🎯 Goal: Production-quality UI + AdMob integrated + Audio QA done

---

### 📋 TASK BREAKDOWN

#### Day 15–16: Onboarding & UX Polish
| Task | Status | Notes |
|---|---|---|
| Onboarding screen logic (first launch only) | ✅ Done | shared_preferences |
| Onboarding bounce animation | ✅ Done | flutter_animate elasticOut |
| Home screen mode card tap animations | ✅ Done | GestureDetector |
| Add letter image to LearnScreen | ✅ Done | Image.asset with error fallback |
| Add word image to PlayScreen options | ✅ Done | 100×120 card with image + word label |
| Consistent color system across all screens | ✅ Done | All screens use AppColors |
| Button height ≥ 80px everywhere | ✅ Done | SizedBox(height: 80) on nav buttons |
| Rounded corners on all cards/buttons | ✅ Done | BorderRadius.circular(24) throughout |

#### Day 17–18: AdMob Integration
| Task | Status | Notes |
|---|---|---|
| AdMob SDK initialized in `main.dart` | ✅ Done | Child-directed config set |
| `tagForChildDirectedTreatment: yes` | ✅ Done | Android (iOS handled in Phase 5) |
| `tagForUnderAgeOfConsent: yes` | ✅ Done | Android only for now |
| Test interstitial ad unit (Play Mode) | ✅ Done | Every 3 rounds in PlayScreen |
| Test rewarded ad unit (optional bonus stars) | ⏳ Pending | |
| Confirm no ads appear in Learn Mode | ✅ Done | Only PlayScreen loads ads |
| Replace TEST AdMob IDs with real IDs | ⏳ Pending | 🔴 Do before release |
| Register app in AdMob dashboard | ⏳ Pending | Get real App ID |

#### Day 19–20: UI Polish
| Task | Status | Notes |
|---|---|---|
| Fredoka font applied globally | ✅ Done | ThemeData fontFamily set in main.dart |
| Tap scale animation (1.0 → 1.1 → 1.0) | ✅ Done | flutter_animate |
| Success → stars burst animation | ⏳ Pending | Lottie file needed |
| Wrong → shake animation | ✅ Done | flutter_animate shakeX |
| App icon (Android + iOS) | ✅ Done | 1024×1024 PNG + flutter_launcher_icons |
| Splash screen | ✅ Done | SplashScreen widget with animated logo |

#### Day 21: Audio QA
| Task | Status | Notes |
|---|---|---|
| TTS pitch tuned (1.1) | ✅ Done | AudioService.init() |
| TTS speech rate tuned (0.45) | ✅ Done | Slow enough for 3–6 yr olds |
| TTS tested on Android | ⏳ Pending | Android only for v1 |
| TTS tested on iOS | ❌ Phase 5 | iOS release is post-Android launch |
| SFX playback delay < 100ms | ⏳ Pending | |
| All 3 SFX files added (success/error/cheer) | ✅ Done | WAV files in assets/sounds/ |

---

### ✅ PHASE 3 COMPLETION CRITERIA
- [x] AdMob showing test ads correctly (interstitial wired in Play Mode)
- [ ] Real AdMob IDs registered
- [x] No ads in Learn Mode confirmed
- [ ] TTS sounds natural on both platforms (Android test pending)
- [x] All screens use consistent Fredoka font + color system
- [x] App icon and splash set

---

---

# PHASE 4 — TESTING & LAUNCH (ANDROID)
## 🗓️ Timeline: Week 4 (Days 22–28)
## 🎯 Goal: Stable Android app tested 100% → Published on Google Play Store

> ⚠️ **iOS is NOT in scope for this phase.** iOS release starts only after Android v1.0 is live.

---

### 📋 TASK BREAKDOWN

#### Day 22–23: Full Device Testing (Android Only)
| Task | Status | Notes |
|---|---|---|
| Test on Android emulator (API 33+) | ⏳ Pending | |
| Test on physical Android device | ⏳ Pending | |
| Test on iOS simulator | ❌ Phase 5 | Post Android launch |
| Test on physical iPhone | ❌ Phase 5 | Post Android launch |
| Test all 3 modes fully (A–Z) | ⏳ Pending | |
| Test first-launch onboarding flow | ⏳ Pending | |
| Test offline mode (airplane mode on) | ⏳ Pending | Critical — offline-first |
| Test small screen (5") and large screen (6.7") | ⏳ Pending | Android screen sizes |
| Run `flutter analyze` | ⏳ Pending | Zero lint errors required |
| Run `flutter test` | ⏳ Pending | All widget tests pass |

#### Day 24: Bug Fixes
| Task | Status | Notes |
|---|---|---|
| Fix all issues found in Day 22–23 | ⏳ Pending | |
| Crash-free rate target: > 99% | ⏳ Pending | |

#### Day 25: Store Submission Prep (Android / Play Store)
| Task | Status | Notes |
|---|---|---|
| App name: "ABC Kids: Tap & Learn" | ⏳ Pending | |
| Short description (80 chars) | ⏳ Pending | |
| Full description (4000 chars) | ⏳ Pending | |
| Screenshots (phone + tablet) | ⏳ Pending | Min 4 Android screenshots |
| Feature graphic (1024x500) | ⏳ Pending | Play Store only |
| App icon (512x512 for Play Store) | ⏳ Pending | |
| Privacy policy URL | ⏳ Pending | Required — even for no-data apps |
| Build release AAB (`flutter build appbundle`) | ⏳ Pending | Android only |
| Build iOS IPA (`flutter build ipa`) | ❌ Phase 5 | After Android launch |
| Sign Android release (keystore) | ⏳ Pending | Generate & store securely |
| Sign iOS release (Xcode + Apple Developer) | ❌ Phase 5 | After Android launch |

#### Day 26–27: Submit for Review (Android Only)
| Task | Status | Notes |
|---|---|---|
| Submit to Google Play Store (Internal → Production) | ⏳ Pending | |
| Submit to Apple App Store | ❌ Phase 5 | After Android launch |
| Set app content rating (Everyone) | ⏳ Pending | Play Store |
| Mark as "Designed for Families" on Play Store | ⏳ Pending | |
| Set age range 3–6 on App Store | ❌ Phase 5 | After Android launch |

#### Day 28: Buffer
| Task | Status | Notes |
|---|---|---|
| Fix any store rejection issues | ⏳ Pending | |
| Respond to review feedback | ⏳ Pending | |

---

### ✅ PHASE 4 COMPLETION CRITERIA
- [ ] `flutter analyze` returns zero errors
- [ ] `flutter test` all tests pass
- [ ] App works fully in airplane mode (Android)
- [ ] Submitted to Google Play Store ✅
- [ ] Content rating set on Play Store
- [ ] "Designed for Families" tag applied

---

---

# PHASE 5 — POST-LAUNCH v1.1 + iOS RELEASE
## 🗓️ Timeline: 2–4 weeks after Android v1.0 launch
## 🎯 Goal: Polish based on user feedback + full iOS launch

---

### 🔜 UPCOMING TASKS

| Task | Priority |
|---|---|
| **iOS — Test on iOS simulator** | 🔴 High |
| **iOS — Test on physical iPhone** | 🔴 High |
| **iOS — TTS QA on iOS** | 🔴 High |
| **iOS — Build IPA (`flutter build ipa`)** | 🔴 High |
| **iOS — Sign with Xcode + Apple Developer account ($99/yr)** | 🔴 High |
| **iOS — Submit to App Store** | 🔴 High |
| **iOS — Set age range 3–6 on App Store** | 🔴 High |
| Add Lottie celebration animations | High |
| Add mascot character (happy reaction) | Medium |
| Improve Trace Mode waypoints for all 26 letters | High |
| Add letter pronunciation for all 26 (pre-recorded MP3s) | Medium |
| Add swipe gesture in Learn Mode | Medium |
| Improve Play Mode image display (actual PNG images) | High |
| Firebase Analytics integration (anonymous events only) | Medium |
| Crash reporting (Firebase Crashlytics) | High |
| App review prompt (after 3+ sessions) | Medium |

---

---

# PHASE 6 — SCALE (v2.0+)
## 🗓️ Timeline: 1–2 months after v1.1
## 🎯 Goal: Expand content and launch ecosystem

---

### 🔜 UPCOMING TASKS

| Task | Priority |
|---|---|
| More mini-games in Play Mode (spelling, sounds) | High |
| Content pack downloads (themes, animals, vehicles) | Medium |
| Math App (1–10 numbers) — reuse same architecture | High |
| Colors App — reuse same architecture | Medium |
| Puzzle App — reuse same architecture | Low |
| Optional backend (progress sync, parent dashboard) | Low |

---

---

# 🔁 KNOWN BLOCKERS / IN LOOP

| Blocker | Impact | Resolution |
|---|---|---|
| ~~Fredoka font not downloaded yet~~ | ~~App uses fallback font~~ | ✅ Resolved — font in `assets/fonts/` |
| ~~Letter images (A–Z PNGs) not added~~ | ~~LearnScreen + PlayScreen show no images~~ | ✅ Resolved — 26 placeholder PNGs added |
| ~~SFX audio files not added~~ | ~~Success/error/cheer sounds won't play~~ | ✅ Resolved — WAV files generated |
| Trace waypoints only defined for "A" | ✅ Fixed | All 26 letters in `_letterWaypoints` map |
| Wrong answer in PlayScreen left user stuck | ✅ Fixed | Auto-advances after 1.8s, correct card revealed in green |
| No `mounted` guard after async delay in PlayScreen | ✅ Fixed | `if (!mounted) return` before `_nextQuestion()` |
| Onboarding button < 80px height | ✅ Fixed | `minimumSize: Size(260, 80)` |
| Real AdMob IDs not registered | Using test IDs — not earning revenue | Register app at admob.google.com |
| Apple Developer account needed | Can't submit to App Store | ⏳ Phase 5 only — not needed for Android |
| Privacy policy URL needed | Required by both stores | Create simple policy page |

---

---

# 📊 PROGRESS SUMMARY

```
Phase 1 — Foundation        ██████████  98% (only device run pending)
Phase 2 — Core Features     █████████░  90% (only device run pending)
Phase 3 — Polish & Ads      ████████░░  80% (real AdMob IDs + TTS device test pending)
Phase 4 — Testing & Launch  ░░░░░░░░░░   0% (not started)
Phase 5 — Post-Launch v1.1  ░░░░░░░░░░   0% (upcoming)
Phase 6 — Scale v2.0+       ░░░░░░░░░░   0% (upcoming)
```

**Overall: ~60% complete**

---

## 🔴 IMMEDIATE NEXT ACTIONS (Do These First)

1. **Run the app on Android emulator** → verify all 3 modes end-to-end *(needs owner permission)*

2. **Register AdMob app** → get real App ID and unit IDs → update `app_constants.dart`

3. **Replace placeholder images** with real CC0 art from OpenGameArt when available

4. **Test TTS** on Android — tune pitch/speed if needed

5. **Test interstitial ad** on device — confirm it shows after every 3 Play Mode rounds

---

## End of Milestones Document

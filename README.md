# 📱 ABC Kids: Tap & Learn

> An offline-first phonics learning app for kids aged 3–6. Built with Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.32%2B-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.8%2B-blue?logo=dart)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green)
![License](https://img.shields.io/badge/License-Private-lightgrey)
![Status](https://img.shields.io/badge/Status-In%20Development-orange)

---

## 🎯 What is this?

**ABC Kids: Tap & Learn** is a high-retention, offline-first kids learning app that teaches the alphabet using:

- 🔊 **Sound-first phonics** — kids hear the letter and word instantly
- 👆 **Instant tap interaction** — no waiting, no menus
- 🌟 **Micro-reward system** — stars and confetti keep kids engaged
- 📶 **Fully offline** — no internet required, ever

---

## 🧩 App Modes

| Mode | Description |
|---|---|
| 📖 **Learn Mode** | Tap a letter to hear its sound. Tap the image to hear the word. Swipe to navigate A–Z. |
| 🎮 **Play Mode** | "Match the Letter" game. Pick the correct image for the shown letter. Stars + confetti for rewards. |
| ✍️ **Trace Mode** | Trace dotted letters with your finger. Uses waypoint detection — no strict accuracy needed. |

---

## 🚀 Getting Started

### Prerequisites

- Flutter `3.32+` / Dart `3.8+`
- Android Studio or Xcode (for device/emulator)
- A physical device or emulator

### Setup

```bash
# 1. Clone the repo
git clone https://github.com/mhashirmaroof/abc_kids_game.git
cd abc_kids_game

# 2. Install dependencies
flutter pub get

# 3. Add required assets (see Assets section below)

# 4. Run the app
flutter run
```

---

## 📦 Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter |
| Language | Dart |
| State Management | flutter_riverpod `^2.6.1` |
| Audio (TTS) | flutter_tts `^4.2.0` — offline, no API key |
| Audio (SFX) | audioplayers `^6.1.0` |
| Ads | google_mobile_ads `^5.3.0` — child-directed |
| First Launch | shared_preferences `^2.3.5` |
| Animations | lottie `^3.3.0` + confetti `^0.8.0` + flutter_animate `^4.5.2` |

---

## 📁 Project Structure

```
lib/
├── main.dart                   # App entry point, AdMob + TTS init
├── constants/
│   └── app_constants.dart      # Colors, fonts, strings, AdMob IDs
├── models/
│   └── letter_model.dart       # Letter data model
├── providers/
│   └── app_providers.dart      # Riverpod state providers
├── services/
│   ├── audio_service.dart      # TTS + SFX wrapper
│   └── alphabet_service.dart   # JSON data loader
└── screens/
    ├── onboarding_screen.dart  # First-run welcome (shown once)
    ├── home_screen.dart        # Mode selection
    ├── learn_screen.dart       # Learn Mode
    ├── play_screen.dart        # Play Mode (match the letter)
    └── trace_screen.dart       # Trace Mode (CustomPainter + waypoints)

assets/
├── data/
│   └── alphabet.json           # A–Z letter/word/image/sound data
├── images/                     # Letter images (open-source PNGs)
├── sounds/                     # Letter + SFX audio (open-source MP3s)
├── animations/                 # Lottie JSON files
└── fonts/                      # Fredoka font files
```

---

## 🖼️ Assets

All assets must be **free, open-source, or public domain**.

### Recommended Sources

| Asset Type | Source | License |
|---|---|---|
| Letter images | [OpenGameArt.org](https://opengameart.org) | CC0 |
| Sound effects | [Freesound.org](https://freesound.org) | CC0 / CC-BY |
| Letter/word TTS | `flutter_tts` (on-device) | Built-in, no key |
| Animations | [LottieFiles.com](https://lottiefiles.com) | Free tier |
| Font (Fredoka) | [Google Fonts](https://fonts.google.com/specimen/Fredoka) | OFL |

### Required Audio Files

Place these in `assets/sounds/`:

```
success.mp3   — correct answer cheer
error.mp3     — wrong answer soft sound
cheer.mp3     — milestone (every 5 stars) celebration
a.mp3 – z.mp3 — phonics sounds for each letter (optional if using flutter_tts)
```

---

## 💰 Monetization

- **Google AdMob** — child-directed mode enabled
- Interstitial ads after every 2–3 game rounds
- No ads in Learn Mode
- Rewarded ads (optional) to unlock bonus content

> ⚠️ Before release, replace the test AdMob IDs in `lib/constants/app_constants.dart` with your real AdMob unit IDs.

---

## 🔒 Privacy

- ❌ No user accounts or login
- ❌ No personal data collected
- ❌ No backend or server
- ✅ COPPA / GDPR compliant — nothing stored or transmitted about the user
- ✅ AdMob configured with `tagForChildDirectedTreatment: yes`

---

## 📈 Target KPIs

| Metric | Target |
|---|---|
| Avg session duration | > 3 min |
| D1 retention | > 40% |
| D7 retention | > 20% |
| Ad impressions / session | ≥ 2 |
| Crash-free rate | > 99% |
| Store rating | ≥ 4.2 ⭐ |

---

## 🗺️ Roadmap

| Phase | Features |
|---|---|
| **v1.0** — Current | A–Z Learn, Play, Trace modes + AdMob |
| **v1.1** | Full asset polish, Lottie animations, mascot character |
| **v2.0** | More mini-games, better animations, content packs |
| **v3.0** | Math App, Colors App (same architecture reused) |

---

## 🤝 Contributing

This is a private project. Not open for external contributions at this time.

---

## 📄 License

Private — All rights reserved © 2026 Hashir Maroof

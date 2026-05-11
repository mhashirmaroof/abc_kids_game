// App-wide constants

class AppColors {
  // Legacy (kept for trace painter)
  static const yellow  = 0xFFFFD93D;
  static const blue    = 0xFF4D96FF;
  static const red     = 0xFFFF6B6B;
  static const green   = 0xFF6BCB77;
  static const white   = 0xFFFFFFFF;
  static const bgLight = 0xFFFFF8F0;

  // ── New Design System ─────────────────────────────────────────────────────
  // Backgrounds
  static const bgDark1      = 0xFF0D0D2B;  // deep navy
  static const bgDark2      = 0xFF1A1A4E;  // mid navy
  static const bgDark3      = 0xFF16213E;  // dark blue

  // Accent colors
  static const neonBlue     = 0xFF4DFFEF;  // electric cyan
  static const neonPurple   = 0xFFBB86FC;  // soft purple
  static const neonYellow   = 0xFFFFE566;  // warm yellow
  static const neonCoral    = 0xFFFF6584;  // coral pink
  static const neonGreen    = 0xFF69FF97;  // lime green
  static const neonOrange   = 0xFFFFAA5C;  // warm orange

  // Card colors (semi-transparent)
  static const cardLearn    = 0xFF1E3A5F;  // deep blue card
  static const cardPlay     = 0xFF3D1E5F;  // deep purple card
  static const cardTrace    = 0xFF1E5F3A;  // deep green card

  // Text
  static const textPrimary  = 0xFFFFFFFF;
  static const textSecondary= 0xFFB0B8D4;
}

class AppFonts {
  static const fredoka = 'Fredoka';
}

class AppAssets {
  static const alphabetData  = 'assets/data/alphabet.json';
  static const successSound  = 'assets/sounds/success.wav';
  static const errorSound    = 'assets/sounds/error.wav';
  static const cheerSound    = 'assets/sounds/cheer.wav';
}

class AppStrings {
  static const appName    = 'ABC Kids: Tap & Learn';
  static const learnMode  = 'Learn';
  static const playMode   = 'Play';
  static const traceMode  = 'Trace';
}

class AdConfig {
  // ── Official Google Demo (Test) Ad IDs ──────────────────────────────────────
  // Source: https://developers.google.com/admob/android/test-ads
  // ✅ Safe to use during development — no real charges, no invalid traffic risk
  // 🔴 Replace ALL IDs below with your real AdMob IDs before Play Store release
  // 💡 Android emulators are automatically configured as test devices by Google

  // Test App IDs (required in AndroidManifest.xml — already added)
  static const androidTestAppId        = 'ca-app-pub-3940256099942544~3347511713';
  static const iosTestAppId            = 'ca-app-pub-3940256099942544~1458002511';

  // Android test ad unit IDs
  static const androidBannerId         = 'ca-app-pub-3940256099942544/6300978111';
  static const androidInterstitialId   = 'ca-app-pub-3940256099942544/1033173712';
  static const androidRewardedId       = 'ca-app-pub-3940256099942544/5224354917';
  static const androidRewardedInterId  = 'ca-app-pub-3940256099942544/5354046379';
  static const androidNativeId         = 'ca-app-pub-3940256099942544/2247696110';
  static const androidAppOpenId        = 'ca-app-pub-3940256099942544/9257395921';

  // iOS test ad unit IDs (Phase 5 — not used until iOS release)
  static const iosBannerId             = 'ca-app-pub-3940256099942544/2934735716';
  static const iosInterstitialId       = 'ca-app-pub-3940256099942544/4411468910';
  static const iosRewardedId           = 'ca-app-pub-3940256099942544/1712485313';
}

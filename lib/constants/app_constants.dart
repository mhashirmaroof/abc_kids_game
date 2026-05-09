// App-wide constants

class AppColors {
  static const yellow  = 0xFFFFD93D;
  static const blue    = 0xFF4D96FF;
  static const red     = 0xFFFF6B6B;
  static const green   = 0xFF6BCB77;
  static const white   = 0xFFFFFFFF;
  static const bgLight = 0xFFFFF8F0;
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

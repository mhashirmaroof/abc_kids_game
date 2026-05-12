import 'package:flutter/material.dart';

// App-wide constants

class AppColors {
  // ── Background ────────────────────────────────────────────────────────────
  static const bgLight      = 0xFFF5F3FF;  // soft lavender-white
  static const bgCard       = 0xFFFFFFFF;

  // ── Brand gradient (appbars, splash, onboarding) ──────────────────────────
  static const gradStart    = 0xFF7C3AED;  // vivid violet
  static const gradEnd      = 0xFF4F46E5;  // indigo

  // ── Mode accent colours ───────────────────────────────────────────────────
  static const learnStart   = 0xFFF97316;  // orange
  static const learnEnd     = 0xFFEF4444;  // coral-red
  static const playStart    = 0xFF3B82F6;  // blue
  static const playEnd      = 0xFF6366F1;  // indigo
  static const traceStart   = 0xFF10B981;  // emerald
  static const traceEnd     = 0xFF059669;  // deep green

  // ── UI feedback ───────────────────────────────────────────────────────────
  static const starGold     = 0xFFF59E0B;
  static const successGreen = 0xFF10B981;
  static const errorRed     = 0xFFEF4444;
  static const textDark     = 0xFF1E1B4B;
  static const textMid      = 0xFF6B7280;

  // ── Legacy aliases (keep so no other file breaks) ────────────────────────
  static const yellow = learnStart;
  static const blue   = playStart;
  static const red    = errorRed;
  static const green  = traceStart;
  static const white  = bgCard;
}

class AppGradients {
  static const brand = LinearGradient(
    colors: [Color(AppColors.gradStart), Color(AppColors.gradEnd)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const learn = LinearGradient(
    colors: [Color(AppColors.learnStart), Color(AppColors.learnEnd)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const play = LinearGradient(
    colors: [Color(AppColors.playStart), Color(AppColors.playEnd)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
  static const trace = LinearGradient(
    colors: [Color(AppColors.traceStart), Color(AppColors.traceEnd)],
    begin: Alignment.topLeft, end: Alignment.bottomRight,
  );
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants/app_constants.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';
import 'services/audio_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // AdMob: child-directed treatment (REQUIRED for kids app)
  await MobileAds.instance.initialize();
  await MobileAds.instance.updateRequestConfiguration(
    RequestConfiguration(
      tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
      tagForUnderAgeOfConsent: TagForUnderAgeOfConsent.yes,
    ),
  );

  // Audio init
  await AudioService.init();

  // First launch check
  final prefs = await SharedPreferences.getInstance();
  final isFirstLaunch = prefs.getBool('first_launch') ?? true;
  if (isFirstLaunch) await prefs.setBool('first_launch', false);

  runApp(
    ProviderScope(
      child: ABCKidsApp(showOnboarding: isFirstLaunch),
    ),
  );
}

class ABCKidsApp extends StatelessWidget {
  final bool showOnboarding;
  const ABCKidsApp({super.key, required this.showOnboarding});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: AppFonts.fredoka,
        scaffoldBackgroundColor: const Color(AppColors.bgLight),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(AppColors.blue),
        ),
      ),
      home: showOnboarding ? const OnboardingScreen() : const HomeScreen(),
    );
  }
}

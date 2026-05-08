import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'constants/app_constants.dart';
import 'screens/splash_screen.dart';
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

  runApp(const ProviderScope(child: ABCKidsApp()));
}

class ABCKidsApp extends StatelessWidget {
  const ABCKidsApp({super.key});

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
      home: const SplashScreen(),
    );
  }
}

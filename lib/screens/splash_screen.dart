import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final isFirstLaunch = prefs.getBool('first_launch') ?? true;
    if (isFirstLaunch) await prefs.setBool('first_launch', false);
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) =>
            isFirstLaunch ? const OnboardingScreen() : const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(AppColors.bgLight),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App icon circle
            Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: const Color(AppColors.blue),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(AppColors.blue).withValues(alpha: 0.40),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'ABC',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            )
                .animate()
                .scaleXY(begin: 0.6, end: 1.0, duration: 600.ms, curve: Curves.elasticOut),

            const SizedBox(height: 28),

            // App name
            const Text(
              'ABC Kids',
              style: TextStyle(
                fontSize: 38,
                fontWeight: FontWeight.bold,
                color: Color(AppColors.blue),
                letterSpacing: 1.5,
              ),
            )
                .animate()
                .fadeIn(delay: 400.ms, duration: 500.ms)
                .slideY(begin: 0.3, end: 0),

            const SizedBox(height: 8),

            Text(
              'Tap & Learn',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            )
                .animate()
                .fadeIn(delay: 600.ms, duration: 400.ms),

            const SizedBox(height: 60),

            // Loading dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(AppColors.yellow),
                    shape: BoxShape.circle,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .scaleXY(
                      begin: 0.5,
                      end: 1.3,
                      delay: Duration(milliseconds: i * 150),
                      duration: 500.ms,
                    )
                    .then()
                    .scaleXY(end: 0.5, duration: 500.ms);
              }),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
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
    await Future.delayed(const Duration(milliseconds: 2600));
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
      body: GradientBackground(
        child: Stack(
          children: [
            const StarField(),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Glowing ABC logo
                  NeonCard(
                    glowColor: const Color(AppColors.neonBlue),
                    cardColor: const Color(0x22FFFFFF),
                    borderRadius: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    child: NeonText(
                      'ABC',
                      fontSize: 72,
                      color: const Color(AppColors.neonBlue),
                    ),
                  )
                      .animate()
                      .scaleXY(begin: 0.5, end: 1.0, duration: 700.ms, curve: Curves.elasticOut),

                  const SizedBox(height: 32),

                  // App name
                  NeonText(
                    'ABC Kids',
                    fontSize: 42,
                    color: const Color(AppColors.neonYellow),
                  )
                      .animate()
                      .fadeIn(delay: 500.ms, duration: 500.ms)
                      .slideY(begin: 0.3, end: 0),

                  const SizedBox(height: 8),

                  Text(
                    'Tap · Learn · Trace',
                    style: TextStyle(
                      fontFamily: AppFonts.fredoka,
                      fontSize: 18,
                      color: const Color(AppColors.textSecondary),
                      letterSpacing: 2,
                    ),
                  ).animate().fadeIn(delay: 800.ms),

                  const SizedBox(height: 64),

                  // Animated dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final colors = [
                        const Color(AppColors.neonBlue),
                        const Color(AppColors.neonPurple),
                        const Color(AppColors.neonCoral),
                      ];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: colors[i],
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: colors[i].withValues(alpha: 0.8), blurRadius: 10)],
                        ),
                      )
                          .animate(onPlay: (c) => c.repeat())
                          .scaleXY(
                            begin: 0.5,
                            end: 1.4,
                            delay: Duration(milliseconds: i * 180),
                            duration: 500.ms,
                          )
                          .then()
                          .scaleXY(end: 0.5, duration: 500.ms);
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

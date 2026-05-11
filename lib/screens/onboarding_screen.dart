import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: const [
          Color(0xFF0D0D2B),
          Color(0xFF1A0A3D),
          Color(0xFF0A1F3D),
        ],
        child: Stack(
          children: [
            const StarField(),
            SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Glowing logo
                      NeonCard(
                        glowColor: const Color(AppColors.neonPurple),
                        cardColor: const Color(0x22FFFFFF),
                        borderRadius: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
                        child: Column(
                          children: [
                            NeonText('ABC', fontSize: 80, color: const Color(AppColors.neonBlue)),
                            const SizedBox(height: 4),
                            Text(
                              'KIDS',
                              style: TextStyle(
                                fontFamily: AppFonts.fredoka,
                                fontSize: 28,
                                letterSpacing: 8,
                                color: const Color(AppColors.neonPurple),
                                shadows: [Shadow(color: const Color(AppColors.neonPurple).withValues(alpha: 0.8), blurRadius: 12)],
                              ),
                            ),
                          ],
                        ),
                      )
                          .animate()
                          .scale(duration: 700.ms, curve: Curves.elasticOut),

                      const SizedBox(height: 36),

                      // Title
                      NeonText(
                        'Tap & Learn!',
                        fontSize: 36,
                        color: const Color(AppColors.neonYellow),
                      ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3, end: 0),

                      const SizedBox(height: 12),

                      Text(
                        'Learn all 26 letters with\nsounds, games & tracing!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.fredoka,
                          fontSize: 18,
                          height: 1.5,
                          color: const Color(AppColors.textSecondary),
                        ),
                      ).animate().fadeIn(delay: 600.ms),

                      const SizedBox(height: 16),

                      // Feature pills
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _FeaturePill('📖 Learn', const Color(AppColors.neonBlue)),
                          const SizedBox(width: 10),
                          _FeaturePill('🎮 Play', const Color(AppColors.neonCoral)),
                          const SizedBox(width: 10),
                          _FeaturePill('✍️ Trace', const Color(AppColors.neonGreen)),
                        ],
                      ).animate().fadeIn(delay: 800.ms),

                      const SizedBox(height: 48),

                      // CTA button
                      _GlowButton(
                        label: "Let's Go! 🚀",
                        color: const Color(AppColors.neonBlue),
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        ),
                      ).animate().fadeIn(delay: 1000.ms).slideY(begin: 0.4, end: 0),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String label;
  final Color color;
  const _FeaturePill(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: AppFonts.fredoka,
          fontSize: 14,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _GlowButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _GlowButton({required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 70,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [color, color.withValues(alpha: 0.7)]),
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 4)),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontFamily: AppFonts.fredoka,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}


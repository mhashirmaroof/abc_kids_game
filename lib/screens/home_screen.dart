import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import 'learn_screen.dart';
import 'play_screen.dart';
import 'trace_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            const StarField(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // Header
                    Column(
                      children: [
                        NeonText(
                          'ABC Kids',
                          fontSize: 48,
                          color: const Color(AppColors.neonYellow),
                        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.3, end: 0),

                        const SizedBox(height: 6),

                        Text(
                          'Choose your adventure!',
                          style: TextStyle(
                            fontFamily: AppFonts.fredoka,
                            fontSize: 18,
                            color: const Color(AppColors.textSecondary),
                            letterSpacing: 0.5,
                          ),
                        ).animate().fadeIn(delay: 300.ms),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Mode cards
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ModeTile(
                            label: 'Learn',
                            subtitle: 'See & hear every letter',
                            emoji: '📖',
                            glowColor: const Color(AppColors.neonBlue),
                            gradientColors: const [Color(0xFF0D3B6E), Color(0xFF1A5276)],
                            delay: 200,
                            onTap: () => _navigate(context, const LearnScreen()),
                          ),
                          const SizedBox(height: 20),
                          _ModeTile(
                            label: 'Play',
                            subtitle: 'Quiz & earn stars ⭐',
                            emoji: '🎮',
                            glowColor: const Color(AppColors.neonCoral),
                            gradientColors: const [Color(0xFF6D0D4E), Color(0xFF8E1565)],
                            delay: 350,
                            onTap: () => _navigate(context, const PlayScreen()),
                          ),
                          const SizedBox(height: 20),
                          _ModeTile(
                            label: 'Trace',
                            subtitle: 'Draw letters with your finger',
                            emoji: '✍️',
                            glowColor: const Color(AppColors.neonGreen),
                            gradientColors: const [Color(0xFF0D5E2E), Color(0xFF157A3D)],
                            delay: 500,
                            onTap: () => _navigate(context, const TraceScreen()),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Bottom tagline
                    Text(
                      '✨ Learn A to Z — offline, anytime!',
                      style: TextStyle(
                        fontFamily: AppFonts.fredoka,
                        fontSize: 14,
                        color: const Color(AppColors.textSecondary),
                      ),
                    ).animate().fadeIn(delay: 700.ms),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _ModeTile extends StatelessWidget {
  final String label;
  final String subtitle;
  final String emoji;
  final Color glowColor;
  final List<Color> gradientColors;
  final int delay;
  final VoidCallback onTap;

  const _ModeTile({
    required this.label,
    required this.subtitle,
    required this.emoji,
    required this.glowColor,
    required this.gradientColors,
    required this.delay,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: glowColor.withValues(alpha: 0.4), width: 1.5),
          boxShadow: [
            BoxShadow(color: glowColor.withValues(alpha: 0.25), blurRadius: 20, spreadRadius: 1, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          children: [
            // Emoji bubble
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: glowColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: glowColor.withValues(alpha: 0.4)),
              ),
              child: Center(
                child: Text(emoji, style: const TextStyle(fontSize: 34)),
              ),
            ),
            const SizedBox(width: 20),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontFamily: AppFonts.fredoka,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: glowColor,
                      shadows: [Shadow(color: glowColor.withValues(alpha: 0.6), blurRadius: 8)],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: AppFonts.fredoka,
                      fontSize: 15,
                      color: Colors.white.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
            // Arrow
            Icon(Icons.arrow_forward_ios_rounded, color: glowColor.withValues(alpha: 0.7), size: 20),
          ],
        ),
      )
          .animate()
          .fadeIn(delay: Duration(milliseconds: delay), duration: 500.ms)
          .slideX(begin: 0.15, end: 0),
    );
  }
}

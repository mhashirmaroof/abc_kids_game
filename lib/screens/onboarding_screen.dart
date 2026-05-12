import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppGradients.brand),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(),

                // ── Logo ────────────────────────────────────────────────
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(36),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 2),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 30, offset: const Offset(0, 12)),
                    ],
                  ),
                  child: const Center(
                    child: Text('ABC', style: TextStyle(fontSize: 46, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2)),
                  ),
                )
                    .animate()
                    .scale(duration: 700.ms, curve: Curves.elasticOut),

                const SizedBox(height: 28),

                // ── Title ───────────────────────────────────────────────
                const Text(
                  'ABC Kids',
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 300.ms),

                const SizedBox(height: 8),

                Text(
                  'Tap · Learn · Trace',
                  style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.75), letterSpacing: 1.5),
                  textAlign: TextAlign.center,
                ).animate().fadeIn(delay: 400.ms),

                const SizedBox(height: 48),

                // ── Feature pills ────────────────────────────────────────
                ...[
                  ('📖', 'Learn all 26 letters A–Z'),
                  ('🎮', 'Play picture quiz & earn stars'),
                  ('✏️', 'Trace letters with your finger'),
                ].asMap().entries.map((e) => _FeaturePill(
                      emoji: e.value.$1,
                      label: e.value.$2,
                      delay: 500 + e.key * 100,
                    )),

                const Spacer(),

                // ── CTA Button ───────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(AppColors.gradStart),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                      textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Let's Start! 🚀"),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 900.ms)
                    .slideY(begin: 0.4, end: 0),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final String emoji;
  final String label;
  final int delay;

  const _FeaturePill({required this.emoji, required this.label, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Text(label, style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w600)),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideX(begin: -0.2, end: 0);
  }
}

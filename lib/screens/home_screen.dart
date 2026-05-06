import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'learn_screen.dart';
import 'play_screen.dart';
import 'trace_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '🔤 ABC Kids',
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Tap & Learn', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 48),

              _ModeCard(
                label: AppStrings.learnMode,
                emoji: '📖',
                color: const Color(AppColors.yellow),
                onTap: () => _navigate(context, const LearnScreen()),
              ),
              const SizedBox(height: 16),
              _ModeCard(
                label: AppStrings.playMode,
                emoji: '🎮',
                color: const Color(AppColors.blue),
                onTap: () => _navigate(context, const PlayScreen()),
              ),
              const SizedBox(height: 16),
              _ModeCard(
                label: AppStrings.traceMode,
                emoji: '✍️',
                color: const Color(AppColors.green),
                onTap: () => _navigate(context, const TraceScreen()),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigate(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }
}

class _ModeCard extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final VoidCallback onTap;

  const _ModeCard({
    required this.label,
    required this.emoji,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 90,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Text(label, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

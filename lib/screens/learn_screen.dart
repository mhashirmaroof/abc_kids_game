import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../providers/app_providers.dart';
import '../services/audio_service.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alphabetAsync = ref.watch(alphabetProvider);
    final index = ref.watch(currentIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Learn Mode 📖'),
        backgroundColor: const Color(AppColors.yellow),
      ),
      body: alphabetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alphabet) {
          final letter = alphabet[index];
          return SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Big letter
                GestureDetector(
                  onTap: () => AudioService.speak(letter.letter),
                  child: Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(AppColors.blue),
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Center(
                      child: Text(
                        letter.letter,
                        style: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scaleXY(end: 1.05, duration: 800.ms),

                const SizedBox(height: 24),

                // Word
                GestureDetector(
                  onTap: () => AudioService.speak(letter.word),
                  child: Text(
                    letter.word,
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  ),
                ),

                const SizedBox(height: 40),

                // Navigation row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _NavButton(
                      label: '← Prev',
                      color: const Color(AppColors.red),
                      onTap: index > 0
                          ? () => ref.read(currentIndexProvider.notifier).state = index - 1
                          : null,
                    ),
                    _NavButton(
                      label: 'Next →',
                      color: const Color(AppColors.green),
                      onTap: index < alphabet.length - 1
                          ? () => ref.read(currentIndexProvider.notifier).state = index + 1
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _NavButton({required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      child: Text(label),
    );
  }
}

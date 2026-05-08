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
      backgroundColor: const Color(AppColors.bgLight),
      appBar: AppBar(
        title: const Text('Learn Mode 📖',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(AppColors.yellow),
        foregroundColor: Colors.white,
      ),
      body: alphabetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alphabet) {
          final letter = alphabet[index];
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Progress counter
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Text(
                      '${index + 1} / ${alphabet.length}',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w600),
                    ),
                  ),

                  const Spacer(),

                  // Letter card (tap to hear letter)
                  GestureDetector(
                    onTap: () => AudioService.speak(letter.letter),
                    child: Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        color: const Color(AppColors.blue),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                              color: const Color(AppColors.blue).withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 6)),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          letter.letter,
                          style: const TextStyle(
                              fontSize: 96,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scaleXY(end: 1.05, duration: 800.ms),

                  const SizedBox(height: 28),

                  // Letter image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.asset(
                      letter.image,
                      width: 150,
                      height: 150,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(Icons.image_not_supported,
                            size: 60, color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Word (tap to hear word)
                  GestureDetector(
                    onTap: () => AudioService.speak(letter.word),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(AppColors.yellow).withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(AppColors.yellow), width: 2),
                      ),
                      child: Text(
                        '${letter.word} 🔊',
                        style: const TextStyle(
                            fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Navigation row — height ≥ 80px per PRD
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Row(
                      children: [
                        Expanded(
                          child: _NavButton(
                            label: '← Prev',
                            color: const Color(AppColors.red),
                            onTap: index > 0
                                ? () => ref
                                    .read(currentIndexProvider.notifier)
                                    .state = index - 1
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _NavButton(
                            label: 'Next →',
                            color: const Color(AppColors.green),
                            onTap: index < alphabet.length - 1
                                ? () => ref
                                    .read(currentIndexProvider.notifier)
                                    .state = index + 1
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
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
    return SizedBox(
      height: 80,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24)),
          textStyle:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        child: Text(label),
      ),
    );
  }
}

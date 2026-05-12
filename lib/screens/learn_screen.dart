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
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppGradients.learn)),
        title: const Text('Learn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: alphabetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alphabet) {
          final letter = alphabet[index];
          final progress = (index + 1) / alphabet.length;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Progress bar
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation(Color(AppColors.learnStart)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${index + 1}/${alphabet.length}',
                          style: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
                    ],
                  ),

                  const Spacer(),

                  // Letter card — tap to hear
                  GestureDetector(
                    onTap: () => AudioService.speak(letter.letter),
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        gradient: AppGradients.learn,
                        borderRadius: BorderRadius.circular(36),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(AppColors.learnStart).withValues(alpha: 0.40),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text('', style: TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                      // Rebuild text separately so letter variable is captured
                    ).copyWith(letter: letter.letter),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .scaleXY(end: 1.04, duration: 900.ms),

                  const SizedBox(height: 28),

                  // Letter image
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, 4))],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(28),
                      child: Image.asset(
                        letter.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported, size: 56, color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Word chip — tap to hear
                  GestureDetector(
                    onTap: () => AudioService.speak(letter.word),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: const Color(AppColors.learnStart).withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 4))],
                        border: Border.all(color: const Color(AppColors.learnStart).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.volume_up_rounded, color: Color(AppColors.learnStart), size: 22),
                          const SizedBox(width: 10),
                          Text(letter.word,
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(AppColors.textDark))),
                        ],
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Navigation
                  Padding(
                    padding: const EdgeInsets.only(bottom: 28),
                    child: Row(
                      children: [
                        Expanded(
                          child: _NavButton(
                            label: 'Prev',
                            icon: Icons.arrow_back_ios_rounded,
                            gradient: index > 0 ? AppGradients.brand : null,
                            onTap: index > 0
                                ? () => ref.read(currentIndexProvider.notifier).state = index - 1
                                : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _NavButton(
                            label: 'Next',
                            icon: Icons.arrow_forward_ios_rounded,
                            gradient: index < alphabet.length - 1 ? AppGradients.learn : null,
                            onTap: index < alphabet.length - 1
                                ? () => ref.read(currentIndexProvider.notifier).state = index + 1
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
  final IconData icon;
  final LinearGradient? gradient;
  final VoidCallback? onTap;

  const _NavButton({required this.label, required this.icon, this.gradient, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: isDisabled ? null : gradient,
          color: isDisabled ? Colors.grey.shade200 : null,
          borderRadius: BorderRadius.circular(18),
          boxShadow: isDisabled
              ? []
              : [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 8, offset: const Offset(0, 3))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isDisabled ? Colors.grey : Colors.white, size: 18),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: isDisabled ? Colors.grey : Colors.white)),
          ],
        ),
      ),
    );
  }
}

extension on Container {
  Container copyWith({String? letter}) {
    if (letter == null) return this;
    return Container(
      width: 170,
      height: 170,
      decoration: decoration,
      child: Center(
        child: Text(letter,
            style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}

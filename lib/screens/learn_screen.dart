import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../services/audio_service.dart';

class LearnScreen extends ConsumerWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final alphabetAsync = ref.watch(alphabetProvider);
    final index = ref.watch(currentIndexProvider);

    // Cycle through accent colors per letter
    final accentColors = [
      const Color(AppColors.neonBlue),
      const Color(AppColors.neonPurple),
      const Color(AppColors.neonCoral),
      const Color(AppColors.neonGreen),
      const Color(AppColors.neonOrange),
      const Color(AppColors.neonYellow),
    ];
    final accent = accentColors[index % accentColors.length];

    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            const StarField(),
            SafeArea(
              child: Column(
                children: [
                  // ── AppBar ──────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Text('Learn Mode 📖',
                              style: TextStyle(fontFamily: AppFonts.fredoka, fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      ],
                    ),
                  ),

                  alphabetAsync.when(
                    loading: () => const Expanded(child: Center(child: CircularProgressIndicator(color: Colors.white))),
                    error: (e, _) => Expanded(child: Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white)))),
                    data: (alphabet) {
                      final letter = alphabet[index];
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              // Progress
                              Text(
                                '${index + 1} / ${alphabet.length}',
                                style: TextStyle(
                                  fontFamily: AppFonts.fredoka,
                                  fontSize: 15,
                                  color: const Color(AppColors.textSecondary),
                                ),
                              ),

                              const Spacer(),

                              // Letter card (tap to hear)
                              GestureDetector(
                                onTap: () => AudioService.speak(letter.letter),
                                child: NeonCard(
                                  glowColor: accent,
                                  cardColor: accent.withValues(alpha: 0.12),
                                  borderRadius: 36,
                                  padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                                  child: NeonText(letter.letter, fontSize: 120, color: accent),
                                ),
                              )
                                  .animate(key: ValueKey(index))
                                  .scaleXY(begin: 0.7, end: 1.0, duration: 400.ms, curve: Curves.elasticOut),

                              const SizedBox(height: 28),

                              // Image
                              NeonCard(
                                glowColor: accent.withValues(alpha: 0.6),
                                cardColor: const Color(0x22FFFFFF),
                                borderRadius: 24,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset(
                                    letter.image,
                                    width: 140,
                                    height: 140,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 140,
                                      height: 140,
                                      color: Colors.transparent,
                                      child: Center(
                                        child: Text(letter.word[0], style: TextStyle(fontSize: 80, color: accent.withValues(alpha: 0.3))),
                                      ),
                                    ),
                                  ),
                                ),
                              ).animate(key: ValueKey('img_$index')).fadeIn(duration: 400.ms),

                              const SizedBox(height: 24),

                              // Word tap to hear
                              GestureDetector(
                                onTap: () => AudioService.speak(letter.word),
                                child: NeonCard(
                                  glowColor: const Color(AppColors.neonYellow),
                                  cardColor: const Color(0x22FFFFFF),
                                  borderRadius: 20,
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      NeonText(letter.word, fontSize: 30, color: const Color(AppColors.neonYellow)),
                                      const SizedBox(width: 10),
                                      const Icon(Icons.volume_up_rounded, color: Color(AppColors.neonYellow), size: 28),
                                    ],
                                  ),
                                ),
                              ),

                              const Spacer(),

                              // Navigation
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _NavBtn(
                                        label: '← Prev',
                                        color: const Color(AppColors.neonCoral),
                                        onTap: index > 0
                                            ? () => ref.read(currentIndexProvider.notifier).state = index - 1
                                            : null,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _NavBtn(
                                        label: 'Next →',
                                        color: const Color(AppColors.neonGreen),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onTap;
  const _NavBtn({required this.label, required this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: isDisabled ? const Color(0x33FFFFFF) : color.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isDisabled ? Colors.white24 : color.withValues(alpha: 0.6), width: 1.5),
          boxShadow: isDisabled ? [] : [BoxShadow(color: color.withValues(alpha: 0.25), blurRadius: 12)],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.fredoka,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDisabled ? Colors.white38 : color,
            ),
          ),
        ),
      ),
    );
  }
}


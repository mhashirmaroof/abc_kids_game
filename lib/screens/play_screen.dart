import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../services/audio_service.dart';
import '../models/letter_model.dart';

class PlayScreen extends ConsumerStatefulWidget {
  const PlayScreen({super.key});

  @override
  ConsumerState<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends ConsumerState<PlayScreen> {
  late ConfettiController _confetti;
  int _questionIndex = 0;
  int? _selectedIndex;
  bool _answered = false;
  late List<LetterModel> _alphabet;
  List<List<LetterModel>> _options = [];
  int _roundsPlayed = 0;
  InterstitialAd? _interstitialAd;

  static String get _interstitialId =>
      AdConfig.androidInterstitialId; // Android-first

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
    _loadInterstitial();
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: _interstitialId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitialAd = ad,
        onAdFailedToLoad: (_) => _interstitialAd = null,
      ),
    );
  }

  void _showInterstitialIfReady() {
    if (_interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitial(); // pre-load next one
        },
        onAdFailedToShowFullScreenContent: (ad, _) {
          ad.dispose();
          _interstitialAd = null;
          _loadInterstitial();
        },
      );
      _interstitialAd!.show();
      _interstitialAd = null;
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _buildOptions(List<LetterModel> alphabet) {
    final rng = Random();
    _options = List.generate(alphabet.length, (i) {
      final correct = alphabet[i];
      final pool = List<LetterModel>.from(alphabet)..remove(correct);
      pool.shuffle(rng);
      return [correct, pool[0], pool[1]]..shuffle(rng);
    });
  }

  void _onAnswer(int selectedIdx, List<LetterModel> opts, LetterModel correct) async {
    if (_answered) return;
    setState(() {
      _selectedIndex = selectedIdx;
      _answered = true;
    });

    if (opts[selectedIdx].letter == correct.letter) {
      // ── Correct answer ─────────────────────────────────────────
      await AudioService.playSuccess();
      ref.read(starCountProvider.notifier).state++;
      final stars = ref.read(starCountProvider);
      if (stars % 5 == 0) {
        _confetti.play();
        await AudioService.playCheer();
      }
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;  // guard: screen may have been popped
      _nextQuestion();
    } else {
      // ── Wrong answer — play error, reveal correct, then auto-advance ──
      await AudioService.playError();
      await Future.delayed(const Duration(milliseconds: 1800));
      if (!mounted) return;  // guard
      _nextQuestion();
    }
  }

  void _nextQuestion() {
    _roundsPlayed++;
    // Show interstitial every 3 rounds (Play Mode only — no ads in Learn/Trace)
    if (_roundsPlayed % 3 == 0) _showInterstitialIfReady();
    setState(() {
      _questionIndex = (_questionIndex + 1) % _alphabet.length;
      _answered = false;
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final alphabetAsync = ref.watch(alphabetProvider);
    final stars = ref.watch(starCountProvider);

    return Scaffold(
      backgroundColor: const Color(AppColors.bgDark1),
      body: GradientBackground(
        colors: const [
          Color(AppColors.bgDark1),
          Color(AppColors.bgDark2),
          Color(AppColors.bgDark3),
        ],
        child: Stack(
          children: [
            const StarField(),
            SafeArea(
              child: alphabetAsync.when(
                loading: () => const Center(
                  child: CircularProgressIndicator(
                    color: Color(AppColors.neonBlue),
                  ),
                ),
                error: (e, _) => Center(
                  child: Text('Error: $e',
                      style: const TextStyle(color: Colors.white)),
                ),
                data: (alphabet) {
                  _alphabet = alphabet;
                  if (_options.isEmpty) _buildOptions(alphabet);
                  final correct = alphabet[_questionIndex];
                  final opts = _options[_questionIndex];

                  return Column(
                    children: [
                      // ── Custom AppBar ──────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.white.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white
                                        .withValues(alpha: 0.15),
                                  ),
                                ),
                                child: const Icon(Icons.arrow_back_ios_new,
                                    color: Colors.white, size: 18),
                              ),
                            ),
                            const Spacer(),
                            NeonText(
                              'Play Mode 🎮',
                              color: const Color(AppColors.neonPurple),
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Text('⭐',
                                    style: TextStyle(fontSize: 18)),
                                const SizedBox(width: 4),
                                NeonText(
                                  '$stars',
                                  color: const Color(AppColors.neonYellow),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ── Question Prompt ────────────────────────────────
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 24),
                        child: NeonCard(
                          glowColor: const Color(AppColors.neonBlue),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 8),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.white
                                        .withValues(alpha: 0.07),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: const Color(AppColors.neonBlue)
                                          .withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: const Text(
                                    '🔍  Find the picture for:',
                                    style: TextStyle(
                                      color: Color(AppColors.textSecondary),
                                      fontSize: 13,
                                      letterSpacing: 1.1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                NeonText(
                                  '"${correct.letter}"',
                                  color: const Color(AppColors.neonBlue),
                                  fontSize: 52,
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ).animate().fadeIn(duration: 400.ms).slideY(
                            begin: -0.2,
                            end: 0,
                            duration: 400.ms,
                            curve: Curves.easeOut,
                          ),

                      const SizedBox(height: 40),

                      // ── Option Cards ───────────────────────────────────
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                          children: List.generate(opts.length, (i) {
                            final isCorrect =
                                opts[i].letter == correct.letter;
                            final isSelected = _selectedIndex == i;

                            Color borderColor =
                                Colors.white.withValues(alpha: 0.10);
                            List<BoxShadow> glowShadows = [];

                            if (_answered) {
                              if (isSelected && isCorrect) {
                                borderColor =
                                    const Color(AppColors.neonGreen);
                                glowShadows = [
                                  BoxShadow(
                                    color: const Color(AppColors.neonGreen)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  )
                                ];
                              } else if (isSelected && !isCorrect) {
                                borderColor =
                                    const Color(AppColors.neonCoral);
                                glowShadows = [
                                  BoxShadow(
                                    color: const Color(AppColors.neonCoral)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 18,
                                    spreadRadius: 2,
                                  )
                                ];
                              } else if (!isSelected && isCorrect) {
                                borderColor =
                                    const Color(AppColors.neonGreen);
                                glowShadows = [
                                  BoxShadow(
                                    color: const Color(AppColors.neonGreen)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 14,
                                    spreadRadius: 1,
                                  )
                                ];
                              }
                            }

                            return GestureDetector(
                              onTap: () =>
                                  _onAnswer(i, opts, correct),
                              child: AnimatedContainer(
                                duration: 200.ms,
                                width: 105,
                                height: 130,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0E1E30),
                                  borderRadius:
                                      BorderRadius.circular(20),
                                  border: Border.all(
                                      color: borderColor, width: 2.5),
                                  boxShadow: glowShadows,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(12),
                                      child: Image.asset(
                                        opts[i].image,
                                        width: 64,
                                        height: 64,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.image,
                                                size: 42,
                                                color: Colors.white38),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      opts[i].word,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: _answered && isCorrect
                                            ? const Color(
                                                AppColors.neonGreen)
                                            : Colors.white
                                                .withValues(alpha: 0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                                .animate(
                                    target: isSelected &&
                                            _answered &&
                                            !isCorrect
                                        ? 1
                                        : 0)
                                .shakeX(amount: 8, duration: 400.ms)
                                .animate()
                                .fadeIn(
                                    duration: 400.ms,
                                    delay: Duration(
                                        milliseconds: 100 + i * 120))
                                .slideY(
                                    begin: 0.3,
                                    end: 0,
                                    duration: 400.ms,
                                    delay: Duration(
                                        milliseconds: 100 + i * 120),
                                    curve: Curves.easeOut);
                          }),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // ── Confetti overlay ────────────────────────────────────────
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 30,
                colors: const [
                  Color(AppColors.neonYellow),
                  Color(AppColors.neonBlue),
                  Color(AppColors.neonGreen),
                  Color(AppColors.neonCoral),
                  Color(AppColors.neonPurple),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

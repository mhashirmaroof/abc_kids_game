import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../constants/app_constants.dart';
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
      appBar: AppBar(
        title: Text('Play Mode 🎮  ⭐ $stars'),
        backgroundColor: const Color(AppColors.blue),
        foregroundColor: Colors.white,
      ),
      body: alphabetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alphabet) {
          _alphabet = alphabet;
          if (_options.isEmpty) _buildOptions(alphabet);
          final correct = alphabet[_questionIndex];
          final opts = _options[_questionIndex];

          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      // Question prompt
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 28, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(AppColors.blue).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(AppColors.blue), width: 2),
                        ),
                        child: Text(
                          'Find: "${correct.letter}"',
                          style: const TextStyle(
                              fontSize: 34, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Option cards — full width row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(opts.length, (i) {
                          final isCorrect =
                              opts[i].letter == correct.letter;
                          final isSelected = _selectedIndex == i;

                          // Border logic:
                          // • tapped correct  → green on tapped card
                          // • tapped wrong    → red on tapped card + green on correct card
                          // • not answered yet → transparent
                          Color border = Colors.transparent;
                          if (_answered) {
                            if (isSelected) {
                              border = isCorrect
                                  ? const Color(AppColors.green)
                                  : const Color(AppColors.red);
                            } else if (isCorrect) {
                              border = const Color(AppColors.green);
                            }
                          }
                          return GestureDetector(
                            onTap: () => _onAnswer(i, opts, correct),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              width: 100,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: border, width: 4),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6)
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.center,
                                children: [
                                  // Letter image
                                  ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(12),
                                    child: Image.asset(
                                      opts[i].image,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Icon(Icons.image,
                                              size: 40,
                                              color: Colors.grey),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    opts[i].word,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ).animate(
                              target: isSelected &&
                                      _answered &&
                                      opts[i].letter != correct.letter
                                  ? 1
                                  : 0)
                            .shakeX(amount: 8, duration: 400.ms);
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              ConfettiWidget(
                confettiController: _confetti,
                blastDirectionality: BlastDirectionality.explosive,
                numberOfParticles: 30,
                colors: const [
                  Color(AppColors.yellow),
                  Color(AppColors.blue),
                  Color(AppColors.green),
                  Color(AppColors.red)
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

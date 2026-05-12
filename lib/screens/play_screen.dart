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

  static String get _interstitialId => AdConfig.androidInterstitialId;

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
          _loadInterstitial();
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
      await AudioService.playSuccess();
      ref.read(starCountProvider.notifier).state++;
      final stars = ref.read(starCountProvider);
      if (stars % 5 == 0) {
        _confetti.play();
        await AudioService.playCheer();
      }
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      _nextQuestion();
    } else {
      await AudioService.playError();
      await Future.delayed(const Duration(milliseconds: 1800));
      if (!mounted) return;
      _nextQuestion();
    }
  }

  void _nextQuestion() {
    _roundsPlayed++;
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
      backgroundColor: const Color(AppColors.bgLight),
      appBar: AppBar(
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppGradients.play)),
        title: const Text('Play', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const Text('⭐', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 5),
                Text('$stars', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
        ],
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                  child: Column(
                    children: [
                      // ── Question card ─────────────────────────────────
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
                        decoration: BoxDecoration(
                          gradient: AppGradients.play,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(AppColors.playStart).withValues(alpha: 0.35),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text('Which picture starts with',
                                style: TextStyle(fontSize: 15, color: Colors.white.withValues(alpha: 0.85))),
                            const SizedBox(height: 6),
                            Text('"${correct.letter}"',
                                style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: Colors.white)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── Option cards ──────────────────────────────────
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: List.generate(opts.length, (i) {
                            final isCorrect = opts[i].letter == correct.letter;
                            final isSelected = _selectedIndex == i;

                            Color borderColor = Colors.transparent;
                            Color cardColor = Colors.white;
                            if (_answered) {
                              if (isCorrect) {
                                borderColor = const Color(AppColors.successGreen);
                                cardColor = const Color(AppColors.successGreen).withValues(alpha: 0.08);
                              } else if (isSelected) {
                                borderColor = const Color(AppColors.errorRed);
                                cardColor = const Color(AppColors.errorRed).withValues(alpha: 0.06);
                              }
                            }

                            return Expanded(
                              child: GestureDetector(
                                onTap: () => _onAnswer(i, opts, correct),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  margin: const EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    color: cardColor,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: borderColor, width: 3),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.07),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(14),
                                        child: Image.asset(
                                          opts[i].image,
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) =>
                                              const Icon(Icons.image, size: 48, color: Colors.grey),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        opts[i].word,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 14, fontWeight: FontWeight.bold, color: Color(AppColors.textDark)),
                                      ),
                                    ],
                                  ),
                                ).animate(
                                    target: isSelected && _answered && !isCorrect ? 1 : 0)
                                  .shakeX(amount: 8, duration: 400.ms),
                              ),
                            );
                          }),
                        ),
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
                  Color(AppColors.starGold),
                  Color(AppColors.playStart),
                  Color(AppColors.successGreen),
                  Color(AppColors.errorRed),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

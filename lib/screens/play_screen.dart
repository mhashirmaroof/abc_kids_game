import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
  late List<List<LetterModel>> _options;

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _confetti.dispose();
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
      _nextQuestion();
    } else {
      await AudioService.playError();
    }
  }

  void _nextQuestion() {
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
                      Text('Find: "${correct.letter}"',
                          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(opts.length, (i) {
                          final isCorrect = opts[i].letter == correct.letter;
                          final isSelected = _selectedIndex == i;
                          Color border = Colors.transparent;
                          if (_answered && isSelected) {
                            border = isCorrect ? const Color(AppColors.green) : const Color(AppColors.red);
                          }
                          return GestureDetector(
                            onTap: () => _onAnswer(i, opts, correct),
                            child: AnimatedContainer(
                              duration: 200.ms,
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: border, width: 4),
                                boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 6)],
                              ),
                              child: Center(child: Text(opts[i].word, textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
                            ),
                          ).animate(target: isSelected && _answered && opts[i].letter != correct.letter ? 1 : 0)
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
                colors: const [Color(AppColors.yellow), Color(AppColors.blue), Color(AppColors.green), Color(AppColors.red)],
              ),
            ],
          );
        },
      ),
    );
  }
}

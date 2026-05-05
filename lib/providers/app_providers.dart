import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/letter_model.dart';
import '../services/alphabet_service.dart';

// ── Alphabet data provider ──────────────────────────────────────
final alphabetProvider = FutureProvider<List<LetterModel>>((ref) {
  return AlphabetService.loadAlphabet();
});

// ── Current letter index (Learn & Trace mode) ───────────────────
final currentIndexProvider = StateProvider<int>((ref) => 0);

// ── Session star count ──────────────────────────────────────────
final starCountProvider = StateProvider<int>((ref) => 0);

// ── App mode ────────────────────────────────────────────────────
enum AppMode { learn, play, trace }
final appModeProvider = StateProvider<AppMode>((ref) => AppMode.learn);

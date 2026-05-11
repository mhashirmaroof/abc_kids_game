import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../theme/app_theme.dart';
import '../providers/app_providers.dart';
import '../services/audio_service.dart';

// ignore_for_file: unused_import

// ── Waypoints for all 26 letters (normalised 0.0–1.0 coords) ─────────────────
// Rules: NO duplicate points. Each point is a unique position the child must visit.
const Map<String, List<Offset>> _letterWaypoints = {
  'A': [
    Offset(0.50, 0.05), Offset(0.35, 0.35),
    Offset(0.20, 0.65), Offset(0.12, 0.92),
    Offset(0.35, 0.55), Offset(0.65, 0.55),
    Offset(0.80, 0.65), Offset(0.88, 0.92),
  ],
  'B': [
    Offset(0.22, 0.08), Offset(0.22, 0.50), Offset(0.22, 0.92),
    Offset(0.55, 0.08), Offset(0.78, 0.28), Offset(0.55, 0.50),
    Offset(0.78, 0.72), Offset(0.55, 0.92),
  ],
  'C': [
    Offset(0.78, 0.18), Offset(0.50, 0.05), Offset(0.22, 0.22),
    Offset(0.10, 0.50), Offset(0.22, 0.78), Offset(0.50, 0.95),
    Offset(0.78, 0.82),
  ],
  'D': [
    Offset(0.22, 0.08), Offset(0.22, 0.50), Offset(0.22, 0.92),
    Offset(0.52, 0.08), Offset(0.82, 0.28), Offset(0.92, 0.50),
    Offset(0.82, 0.72), Offset(0.52, 0.92),
  ],
  'E': [
    Offset(0.72, 0.08), Offset(0.22, 0.08),
    Offset(0.22, 0.50), Offset(0.62, 0.50),
    Offset(0.22, 0.92), Offset(0.72, 0.92),
  ],
  'F': [
    Offset(0.72, 0.08), Offset(0.22, 0.08),
    Offset(0.22, 0.50), Offset(0.62, 0.50),
    Offset(0.22, 0.92),
  ],
  'G': [
    Offset(0.78, 0.18), Offset(0.50, 0.05), Offset(0.22, 0.22),
    Offset(0.10, 0.50), Offset(0.22, 0.78), Offset(0.50, 0.95),
    Offset(0.78, 0.82), Offset(0.78, 0.50), Offset(0.52, 0.50),
  ],
  'H': [
    Offset(0.22, 0.08), Offset(0.22, 0.50), Offset(0.22, 0.92),
    Offset(0.78, 0.50),                      // crossbar (only once)
    Offset(0.78, 0.08), Offset(0.78, 0.92),
  ],
  'I': [
    Offset(0.35, 0.08), Offset(0.65, 0.08),
    Offset(0.50, 0.50),
    Offset(0.35, 0.92), Offset(0.65, 0.92),
  ],
  'J': [
    Offset(0.35, 0.08), Offset(0.65, 0.08),
    Offset(0.65, 0.50), Offset(0.65, 0.78),
    Offset(0.52, 0.95), Offset(0.30, 0.92), Offset(0.20, 0.78),
  ],
  'K': [
    Offset(0.22, 0.08), Offset(0.22, 0.50), Offset(0.22, 0.92),
    Offset(0.75, 0.08),                      // upper arm (only once)
    Offset(0.75, 0.92),                      // lower arm
  ],
  'L': [
    Offset(0.25, 0.08), Offset(0.25, 0.50),
    Offset(0.25, 0.92), Offset(0.72, 0.92),
  ],
  'M': [
    Offset(0.10, 0.92), Offset(0.10, 0.08),
    Offset(0.50, 0.55),
    Offset(0.90, 0.08), Offset(0.90, 0.92),
  ],
  'N': [
    Offset(0.15, 0.92), Offset(0.15, 0.08),
    Offset(0.85, 0.92), Offset(0.85, 0.08),
  ],
  'O': [
    Offset(0.50, 0.05), Offset(0.80, 0.22), Offset(0.92, 0.50),
    Offset(0.80, 0.78), Offset(0.50, 0.95), Offset(0.20, 0.78),
    Offset(0.08, 0.50), Offset(0.20, 0.22), Offset(0.50, 0.05),
  ],
  'P': [
    Offset(0.22, 0.08), Offset(0.22, 0.50), Offset(0.22, 0.92),
    Offset(0.55, 0.08), Offset(0.75, 0.25),
    Offset(0.55, 0.50),                      // loop closes back — no duplicate of 0.22,0.50
  ],
  'Q': [
    Offset(0.50, 0.05), Offset(0.80, 0.22), Offset(0.92, 0.50),
    Offset(0.80, 0.78), Offset(0.50, 0.95), Offset(0.20, 0.78),
    Offset(0.08, 0.50), Offset(0.20, 0.22),
    Offset(0.62, 0.72), Offset(0.82, 0.92),
  ],
  'R': [
    Offset(0.22, 0.08), Offset(0.22, 0.50), Offset(0.22, 0.92),
    Offset(0.55, 0.08), Offset(0.75, 0.25),
    Offset(0.55, 0.50), Offset(0.78, 0.92),
  ],
  'S': [
    Offset(0.78, 0.15), Offset(0.50, 0.05), Offset(0.22, 0.18),
    Offset(0.20, 0.35), Offset(0.50, 0.50), Offset(0.80, 0.65),
    Offset(0.78, 0.82), Offset(0.50, 0.95), Offset(0.22, 0.85),
  ],
  'T': [
    Offset(0.15, 0.08), Offset(0.50, 0.08), Offset(0.85, 0.08),
    Offset(0.50, 0.50), Offset(0.50, 0.92),
  ],
  'U': [
    Offset(0.18, 0.08), Offset(0.18, 0.65), Offset(0.28, 0.88),
    Offset(0.50, 0.95), Offset(0.72, 0.88), Offset(0.82, 0.65),
    Offset(0.82, 0.08),
  ],
  'V': [
    Offset(0.12, 0.08), Offset(0.28, 0.42),
    Offset(0.50, 0.92),
    Offset(0.72, 0.42), Offset(0.88, 0.08),
  ],
  'W': [
    Offset(0.08, 0.08), Offset(0.22, 0.75),
    Offset(0.38, 0.42), Offset(0.50, 0.75),
    Offset(0.65, 0.42), Offset(0.80, 0.75), Offset(0.92, 0.08),
  ],
  'X': [
    Offset(0.15, 0.08), Offset(0.38, 0.35),
    Offset(0.50, 0.50),                      // center — only once
    Offset(0.62, 0.65), Offset(0.85, 0.92),
    Offset(0.85, 0.08), Offset(0.62, 0.35),
    Offset(0.38, 0.65), Offset(0.15, 0.92),
  ],
  'Y': [
    Offset(0.15, 0.08), Offset(0.32, 0.32),
    Offset(0.50, 0.50),                      // center — only once
    Offset(0.68, 0.32), Offset(0.85, 0.08),
    Offset(0.50, 0.75), Offset(0.50, 0.92),
  ],
  'Z': [
    Offset(0.15, 0.08), Offset(0.85, 0.08),
    Offset(0.15, 0.92), Offset(0.85, 0.92),
  ],
};

// ── TraceScreen ───────────────────────────────────────────────────────────────
class TraceScreen extends ConsumerStatefulWidget {
  const TraceScreen({super.key});

  @override
  ConsumerState<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends ConsumerState<TraceScreen> {
  final List<Offset> _drawnPoints = [];
  bool _completed = false;
  int _hitCount = 0;
  final Set<int> _hitWaypoints = {};
  String _currentLetter = '';

  List<Offset> get _waypoints =>
      _letterWaypoints[_currentLetter] ?? _letterWaypoints['A']!;

  void _onPanUpdate(DragUpdateDetails d, Size size) {
    // Do NOT return early when completed — child can keep drawing freely
    final wps = _waypoints;
    for (int i = 0; i < wps.length; i++) {
      if (_hitWaypoints.contains(i)) continue;
      final wp = Offset(wps[i].dx * size.width, wps[i].dy * size.height);
      if ((d.localPosition - wp).distance < 30.0) {
        _hitWaypoints.add(i);
        _hitCount++;
      }
    }
    // Single setState per pan event — covers point add + waypoint colour change
    setState(() => _drawnPoints.add(d.localPosition));

    // Trigger success only once, after ALL waypoints are hit (100%)
    if (!_completed && _hitCount >= _waypoints.length) {
      setState(() => _completed = true);
      AudioService.playSuccess();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          final total = ref.read(alphabetProvider).valueOrNull?.length ?? 26;
          _nextLetter(total);
        }
      });
    }
  }

  void _reset() {
    setState(() {
      _drawnPoints.clear();
      _hitCount = 0;
      _hitWaypoints.clear();
      _completed = false;
    });
  }

  void _nextLetter(int total) {
    ref.read(currentIndexProvider.notifier).state =
        (ref.read(currentIndexProvider) + 1) % total;
    _reset();
  }

  void _prevLetter(int total) {
    ref.read(currentIndexProvider.notifier).state =
        (ref.read(currentIndexProvider) - 1 + total) % total;
    _reset();
  }

  @override
  Widget build(BuildContext context) {
    final alphabetAsync = ref.watch(alphabetProvider);
    final index = ref.watch(currentIndexProvider);

    return Scaffold(
      body: GradientBackground(
        colors: const [Color(0xFF0A1628), Color(0xFF0D2B1A), Color(0xFF0D0D2B)],
        child: Stack(
          children: [
            const RepaintBoundary(child: StarField()),
            SafeArea(
              child: alphabetAsync.when(
                loading: () => const Center(child: CircularProgressIndicator(color: Colors.white)),
                error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.white))),
                data: (alphabet) {
                  final letter = alphabet[index];

                  // Reset when letter changes
                  if (_currentLetter != letter.letter) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _currentLetter = letter.letter;
                          _drawnPoints.clear();
                          _hitCount = 0;
                          _hitWaypoints.clear();
                          _completed = false;
                        });
                      }
                    });
                  }

                  return Column(
                    children: [
                      // ── AppBar row ───────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Text('Trace Mode ✍️',
                                  style: TextStyle(fontFamily: AppFonts.fredoka, fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh_rounded, color: Color(AppColors.neonGreen)),
                              onPressed: _reset,
                              tooltip: 'Reset',
                            ),
                          ],
                        ),
                      ),

                      // ── Header info ──────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${index + 1} / ${alphabet.length}',
                                style: const TextStyle(fontFamily: AppFonts.fredoka, fontSize: 15, color: Color(AppColors.textSecondary))),
                            NeonText('Trace: ${letter.letter}', fontSize: 26, color: const Color(AppColors.neonGreen)),
                            Text(letter.word,
                                style: const TextStyle(fontFamily: AppFonts.fredoka, fontSize: 15, color: Color(AppColors.textSecondary))),
                          ],
                        ),
                      ),

                      const SizedBox(height: 8),

                      // ── Success / Hint banner ────────────────────────
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _completed
                            ? Container(
                                key: const ValueKey('success'),
                                margin: const EdgeInsets.symmetric(horizontal: 24),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                decoration: BoxDecoration(
                                  color: const Color(AppColors.neonGreen).withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(AppColors.neonGreen).withValues(alpha: 0.6)),
                                  boxShadow: [BoxShadow(color: const Color(AppColors.neonGreen).withValues(alpha: 0.3), blurRadius: 16)],
                                ),
                                child: const Text('🎉 Amazing! Next letter coming…',
                                    style: TextStyle(fontFamily: AppFonts.fredoka, fontSize: 19, color: Color(AppColors.neonGreen), fontWeight: FontWeight.bold)),
                              )
                            : Container(
                                key: const ValueKey('hint'),
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: const Text('Trace the letter with your finger 👆',
                                    style: TextStyle(fontFamily: AppFonts.fredoka, fontSize: 15, color: Color(AppColors.textSecondary))),
                              ),
                      ),

                      // ── Canvas ───────────────────────────────────────
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF0E1E30),
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: const Color(AppColors.neonGreen).withValues(alpha: 0.25), width: 1.5),
                              boxShadow: [
                                BoxShadow(color: const Color(AppColors.neonGreen).withValues(alpha: 0.08), blurRadius: 20, spreadRadius: 2),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  final size = Size(constraints.maxWidth, constraints.maxHeight);
                                  return GestureDetector(
                                    onPanUpdate: (d) => _onPanUpdate(d, size),
                                    onPanEnd: (_) {},
                                    child: CustomPaint(
                                      size: size,
                                      painter: _TracePainter(
                                        letter: letter.letter,
                                        drawnPoints: _drawnPoints,
                                        waypoints: _waypoints,
                                        hitWaypoints: _hitWaypoints,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ── Navigation ───────────────────────────────────
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _prevLetter(alphabet.length),
                                child: Container(
                                  height: 58,
                                  decoration: BoxDecoration(
                                    color: const Color(AppColors.neonCoral).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(AppColors.neonCoral).withValues(alpha: 0.5)),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.arrow_back_ios_rounded, color: Color(AppColors.neonCoral), size: 18),
                                      SizedBox(width: 6),
                                      Text('Prev', style: TextStyle(fontFamily: AppFonts.fredoka, fontSize: 18, color: Color(AppColors.neonCoral), fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => _nextLetter(alphabet.length),
                                child: Container(
                                  height: 58,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(colors: [Color(0xFF0D5E2E), Color(0xFF157A3D)]),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: const Color(AppColors.neonGreen).withValues(alpha: 0.5)),
                                    boxShadow: [BoxShadow(color: const Color(AppColors.neonGreen).withValues(alpha: 0.25), blurRadius: 12)],
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Next', style: TextStyle(fontFamily: AppFonts.fredoka, fontSize: 18, color: Color(AppColors.neonGreen), fontWeight: FontWeight.bold)),
                                      SizedBox(width: 6),
                                      Icon(Icons.arrow_forward_ios_rounded, color: Color(AppColors.neonGreen), size: 18),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── CustomPainter ─────────────────────────────────────────────────────────────
class _TracePainter extends CustomPainter {
  final String letter;
  final List<Offset> drawnPoints;
  final List<Offset> waypoints;
  final Set<int> hitWaypoints;

  _TracePainter({
    required this.letter,
    required this.drawnPoints,
    required this.waypoints,
    required this.hitWaypoints,
  });

  // Cached TextPainter — rebuilt only when letter or size changes
  static String _cachedLetter = '';
  static double _cachedFontSize = 0;
  static TextPainter? _cachedTextPainter;

  @override
  void paint(Canvas canvas, Size size) {
    // ── Ghost letter — cached TextPainter ────────────────────────
    final fontSize = size.height * 0.72;
    if (_cachedLetter != letter || _cachedFontSize != fontSize) {
      _cachedLetter = letter;
      _cachedFontSize = fontSize;
      _cachedTextPainter = TextPainter(
        text: TextSpan(
          text: letter,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: Colors.white.withValues(alpha: 0.06),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
    }
    final tp = _cachedTextPainter!;
    tp.paint(
      canvas,
      Offset((size.width - tp.width) / 2, (size.height - tp.height) / 2),
    );

    // ── Waypoints ────────────────────────────────────────────────
    for (int i = 0; i < waypoints.length; i++) {
      final wp = Offset(waypoints[i].dx * size.width, waypoints[i].dy * size.height);
      final isHit = hitWaypoints.contains(i);
      if (isHit) {
        // Soft glow ring — no MaskFilter, just a translucent circle
        canvas.drawCircle(
          wp, 18,
          Paint()..color = const Color(AppColors.neonGreen).withValues(alpha: 0.20),
        );
        canvas.drawCircle(wp, 12, Paint()..color = const Color(AppColors.neonGreen));
        canvas.drawCircle(wp, 5,  Paint()..color = Colors.white);
      } else {
        canvas.drawCircle(wp, 9, Paint()..color = Colors.white.withValues(alpha: 0.25));
      }
    }

    // ── Drawn path — neon blue, NO MaskFilter ────────────────────
    if (drawnPoints.length > 1) {
      // Wide semi-transparent stroke for glow effect (no GPU blur)
      final glowPaint = Paint()
        ..color = const Color(AppColors.neonBlue).withValues(alpha: 0.22)
        ..strokeWidth = 22
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final solidPaint = Paint()
        ..color = const Color(AppColors.neonBlue)
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      // Build path once — much faster than drawLine in a loop
      final path = Path()..moveTo(drawnPoints[0].dx, drawnPoints[0].dy);
      for (int i = 1; i < drawnPoints.length; i++) {
        path.lineTo(drawnPoints[i].dx, drawnPoints[i].dy);
      }
      canvas.drawPath(path, glowPaint);
      canvas.drawPath(path, solidPaint);
    }
  }

  @override
  bool shouldRepaint(_TracePainter old) =>
      old.drawnPoints.length != drawnPoints.length ||
      old.hitWaypoints.length != hitWaypoints.length ||
      old.letter != letter;
}

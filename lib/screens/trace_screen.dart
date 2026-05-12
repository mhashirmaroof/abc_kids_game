import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../providers/app_providers.dart';
import '../services/audio_service.dart';

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
    bool changed = false;
    for (int i = 0; i < wps.length; i++) {
      if (_hitWaypoints.contains(i)) continue;
      final wp = Offset(wps[i].dx * size.width, wps[i].dy * size.height);
      if ((d.localPosition - wp).distance < 30.0) {   // 30px — easier for kids
        _hitWaypoints.add(i);
        _hitCount++;
        changed = true;
      }
    }
    // Single setState per pan event for performance
    setState(() => _drawnPoints.add(d.localPosition));
    // Trigger success only once, after ALL waypoints are hit (100%)
    if (!_completed && _hitCount >= _waypoints.length) {
      setState(() => _completed = true);
      AudioService.playSuccess();
      // Auto-advance to next letter after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          final total = ref.read(alphabetProvider).valueOrNull?.length ?? 26;
          _nextLetter(total);
        }
      });
    } else if (changed) {
      setState(() {}); // repaint waypoint colours
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
      backgroundColor: const Color(AppColors.bgLight),
      appBar: AppBar(
        flexibleSpace: Container(decoration: const BoxDecoration(gradient: AppGradients.trace)),
        title: const Text('Trace', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        foregroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
              icon: const Icon(Icons.refresh_rounded), onPressed: _reset, tooltip: 'Reset'),
        ],
      ),
      body: alphabetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
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
              // ── Header ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${index + 1} / ${alphabet.length}',
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                    Text('Trace: ${letter.letter}',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    Text(letter.word,
                        style: TextStyle(fontSize: 16, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // ── Success / Hint banner ─────────────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _completed
                    ? Container(
                        key: const ValueKey('success'),
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            gradient: AppGradients.trace,
                            borderRadius: BorderRadius.circular(16)),
                        child: const Text('🎉 Amazing! Next letter coming…',
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
                      )
                    : Container(
                        key: const ValueKey('hint'),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text('Trace the letter with your finger 👆',
                            style: TextStyle(fontSize: 15, color: Colors.grey.shade500)),
                      ),
              ),

              // ── Canvas ────────────────────────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4)),
                        ],
                      ),
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

              // ── Navigation ────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: OutlinedButton.icon(
                          onPressed: () => _prevLetter(alphabet.length),
                          icon: const Icon(Icons.arrow_back_ios),
                          label: const Text('Prev', style: TextStyle(fontSize: 16)),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(AppColors.traceStart), width: 2),
                            foregroundColor: const Color(AppColors.traceStart),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton.icon(
                          onPressed: () => _nextLetter(alphabet.length),
                          icon: const Icon(Icons.arrow_forward_ios),
                          label: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(AppColors.traceStart),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  @override
  void paint(Canvas canvas, Size size) {
    // Ghost letter guide
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.72,
          fontWeight: FontWeight.bold,
          color: Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2),
    );

    // Waypoints
    for (int i = 0; i < waypoints.length; i++) {
      final wp = Offset(waypoints[i].dx * size.width, waypoints[i].dy * size.height);
      final isHit = hitWaypoints.contains(i);
      canvas.drawCircle(wp, isHit ? 14 : 10,
          Paint()..color = isHit ? const Color(AppColors.traceStart) : Colors.grey.withValues(alpha: 0.40));
      if (isHit) canvas.drawCircle(wp, 5, Paint()..color = Colors.white);
    }

    // Drawn path
    final paint = Paint()
      ..color = const Color(AppColors.playStart)
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    for (int i = 1; i < drawnPoints.length; i++) {
      canvas.drawLine(drawnPoints[i - 1], drawnPoints[i], paint);
    }
  }

  @override
  bool shouldRepaint(_TracePainter old) => true;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_constants.dart';
import '../providers/app_providers.dart';
import '../services/audio_service.dart';

class TraceScreen extends ConsumerStatefulWidget {
  const TraceScreen({super.key});

  @override
  ConsumerState<TraceScreen> createState() => _TraceScreenState();
}

class _TraceScreenState extends ConsumerState<TraceScreen> {
  final List<Offset> _drawnPoints = [];
  bool _completed = false;

  // Waypoints for letter "A" (normalised 0–1 coords, scaled on render)
  static const List<Offset> _waypoints = [
    Offset(0.5, 0.1), Offset(0.4, 0.3), Offset(0.3, 0.5),
    Offset(0.2, 0.7), Offset(0.1, 0.9), Offset(0.35, 0.5),
    Offset(0.65, 0.5), Offset(0.7, 0.7), Offset(0.8, 0.9),
    Offset(0.6, 0.3),
  ];

  int _hitCount = 0;
  final Set<int> _hitWaypoints = {};

  void _onPanUpdate(DragUpdateDetails d, Size size) {
    if (_completed) return;
    setState(() => _drawnPoints.add(d.localPosition));
    for (int i = 0; i < _waypoints.length; i++) {
      if (_hitWaypoints.contains(i)) continue;
      final wp = Offset(_waypoints[i].dx * size.width, _waypoints[i].dy * size.height);
      if ((d.localPosition - wp).distance < 22.0) {
        _hitWaypoints.add(i);
        _hitCount++;
      }
    }
    if (_hitCount >= (_waypoints.length * 0.7).ceil() && !_completed) {
      setState(() => _completed = true);
      AudioService.playSuccess();
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

  @override
  Widget build(BuildContext context) {
    final alphabetAsync = ref.watch(alphabetProvider);
    final index = ref.watch(currentIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trace Mode ✍️'),
        backgroundColor: const Color(AppColors.green),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reset),
        ],
      ),
      body: alphabetAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (alphabet) {
          final letter = alphabet[index];
          return Column(
            children: [
              const SizedBox(height: 16),
              Text('Trace the letter: ${letter.letter}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              if (_completed)
                const Text('🎉 Great job!', style: TextStyle(fontSize: 24, color: Color(AppColors.green))),
              Expanded(
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
            ],
          );
        },
      ),
    );
  }
}

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
    // Draw dotted letter guide
    final textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(
          fontSize: size.height * 0.7,
          fontWeight: FontWeight.bold,
          color: Colors.grey.withValues(alpha: 0.2),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, (size.height - textPainter.height) / 2));

    // Draw waypoints
    for (int i = 0; i < waypoints.length; i++) {
      final wp = Offset(waypoints[i].dx * size.width, waypoints[i].dy * size.height);
      canvas.drawCircle(wp, 10,
          Paint()..color = hitWaypoints.contains(i) ? const Color(AppColors.green) : Colors.grey.withValues(alpha: 0.5));
    }

    // Draw user's path
    final paint = Paint()
      ..color = const Color(AppColors.blue)
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    for (int i = 1; i < drawnPoints.length; i++) {
      canvas.drawLine(drawnPoints[i - 1], drawnPoints[i], paint);
    }
  }

  @override
  bool shouldRepaint(_TracePainter old) => true;
}

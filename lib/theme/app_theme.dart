import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        fontFamily: AppFonts.fredoka,
        scaffoldBackgroundColor: const Color(AppColors.bgDark1),
        colorScheme: const ColorScheme.dark(
          primary: Color(AppColors.neonBlue),
          secondary: Color(AppColors.neonPurple),
          surface: Color(AppColors.bgDark2),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: SystemUiOverlayStyle.light,
          titleTextStyle: TextStyle(
            fontFamily: AppFonts.fredoka,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
      );
}

// ── Gradient background wrapper ───────────────────────────────────────────────
class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;

  const GradientBackground({super.key, required this.child, this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ??
              const [
                Color(AppColors.bgDark1),
                Color(AppColors.bgDark2),
                Color(AppColors.bgDark3),
              ],
        ),
      ),
      child: child,
    );
  }
}

// ── Glowing neon card ─────────────────────────────────────────────────────────
class NeonCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final Color cardColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;

  const NeonCard({
    super.key,
    required this.child,
    required this.glowColor,
    this.cardColor = const Color(0x33FFFFFF),
    this.borderRadius = 24,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: glowColor.withValues(alpha: 0.5), width: 1.5),
        boxShadow: [
          BoxShadow(color: glowColor.withValues(alpha: 0.30), blurRadius: 20, spreadRadius: 2),
          BoxShadow(color: glowColor.withValues(alpha: 0.10), blurRadius: 40, spreadRadius: 8),
        ],
      ),
      child: child,
    );
  }
}

// ── Neon text ─────────────────────────────────────────────────────────────────
class NeonText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;

  const NeonText(
    this.text, {
    super.key,
    this.fontSize = 32,
    this.color = const Color(AppColors.neonBlue),
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: AppFonts.fredoka,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        shadows: [
          Shadow(color: color.withValues(alpha: 0.8), blurRadius: 12),
          Shadow(color: color.withValues(alpha: 0.4), blurRadius: 24),
        ],
      ),
    );
  }
}

// ── Animated star widget ──────────────────────────────────────────────────────
class StarField extends StatelessWidget {
  const StarField({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        size: Size.infinite,
        painter: _StarPainter(),
      ),
    );
  }
}

class _StarPainter extends CustomPainter {
  static const _stars = [
    [0.08, 0.06], [0.22, 0.12], [0.55, 0.04], [0.78, 0.09], [0.92, 0.17],
    [0.15, 0.22], [0.40, 0.18], [0.65, 0.25], [0.88, 0.32], [0.05, 0.38],
    [0.30, 0.35], [0.72, 0.40], [0.95, 0.48], [0.12, 0.55], [0.50, 0.52],
    [0.82, 0.58], [0.25, 0.70], [0.60, 0.68], [0.90, 0.72], [0.42, 0.82],
    [0.70, 0.88], [0.18, 0.90], [0.85, 0.94],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.35);
    for (final s in _stars) {
      canvas.drawCircle(
        Offset(s[0] * size.width, s[1] * size.height),
        s[0] > 0.5 ? 1.5 : 2.0,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarPainter old) => false;
}

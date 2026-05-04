import 'dart:math' as math;

import 'package:flutter/material.dart';

class HealthScoreRing extends StatelessWidget {
  const HealthScoreRing({super.key, required this.score, this.size = 140});

  final int score;
  final double size;

  Color get _color {
    if (score >= 70) return const Color(0xFF4CAF50);
    if (score >= 50) return const Color(0xFFFF9800);
    return const Color(0xFFEF5350);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RingPainter(
          fraction: (score / 100).clamp(0.0, 1.0),
          color: _color,
          trackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  fontSize: size * 0.24,
                  fontWeight: FontWeight.bold,
                  color: _color,
                ),
              ),
              Text(
                '/100',
                style: TextStyle(
                  fontSize: size * 0.10,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  const _RingPainter({
    required this.fraction,
    required this.color,
    required this.trackColor,
  });

  final double fraction;
  final Color color;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.10;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Full track
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi, false, trackPaint);
    // Filled arc
    canvas.drawArc(rect, -math.pi / 2, 2 * math.pi * fraction, false, arcPaint);
  }

  @override
  bool shouldRepaint(_RingPainter old) =>
      old.fraction != fraction || old.color != color || old.trackColor != trackColor;
}

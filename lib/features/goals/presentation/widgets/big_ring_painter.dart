import 'dart:math' as math;

import 'package:flutter/material.dart';

class BigRingPainter extends CustomPainter {
  BigRingPainter({
    required this.progress,
    required this.color,
    required this.bgColor,
  });

  final double progress;
  final Color color;
  final Color bgColor;

  @override
  void paint(Canvas canvas, Size size) {
    const sw = 8.0;
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - sw) / 2;

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = bgColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = sw
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(BigRingPainter old) =>
      old.progress != progress || old.color != color;
}

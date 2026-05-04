import 'package:flutter/material.dart';

class GoogleColorIcon extends StatelessWidget {
  const GoogleColorIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 22,
      height: 22,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: GoogleArcPainter()),
          ),
        ],
      ),
    );
  }
}

class GoogleArcPainter extends CustomPainter {
  const GoogleArcPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);

    void arc(Color color, double start, double sweep) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: r * 0.85),
        start,
        sweep,
        false,
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = r * 0.3
          ..strokeCap = StrokeCap.round,
      );
    }

    arc(const Color(0xFFEA4335), -1.22, 1.22);
    arc(const Color(0xFF4285F4), -1.57, -1.57);
    arc(const Color(0xFF34A853), 0.0, 1.57);
    arc(const Color(0xFFFBBC05), 1.57, 1.57);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

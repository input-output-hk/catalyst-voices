import 'package:flutter/material.dart';

/// Paints a right arrow with the short tip and a long horizontal line
/// which fills all the remaining space.
class ArrowRightPainter extends CustomPainter {
  final Color color;

  const ArrowRightPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final start = Offset(0, size.height / 2);
    final end = Offset(size.width - 2, size.height / 2);

    canvas.drawLine(start, end, paint);

    final arrowHead = Path()
      ..moveTo(size.width, size.height / 2)
      ..lineTo(size.width - 10, size.height / 2 - 8)
      ..moveTo(size.width, size.height / 2)
      ..lineTo(size.width - 10, size.height / 2 + 8);

    canvas.drawPath(arrowHead, paint);
  }

  @override
  bool shouldRepaint(ArrowRightPainter oldDelegate) {
    return color != oldDelegate.color;
  }
}

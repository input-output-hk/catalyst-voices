import 'dart:math';

import 'package:flutter/widgets.dart';

class BubbleConfig {
  final double x;
  final double y;
  final double radius;
  final List<Color> gradientColors;
  final List<double> gradientStops;
  final double? shadowBlur;
  final Offset? shadowOffset;
  final Color? shadowColor;

  BubbleConfig({
    required this.x,
    required this.y,
    required this.radius,
    required this.gradientColors,
    required this.gradientStops,
    this.shadowBlur,
    this.shadowOffset,
    this.shadowColor,
  });
}

class BubblePainter extends CustomPainter {
  final List<BubbleConfig> bubbles;
  final List<ShapeConfig> shapes;
  final Color? backgroundColor;

  const BubblePainter({
    required this.bubbles,
    required this.shapes,
    this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    for (final bubble in bubbles) {
      _drawBubble(canvas, bubble);
    }
    for (final shape in shapes) {
      _drawShape(canvas, size, shape: shape);
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) =>
      bubbles != oldDelegate.bubbles || shapes != oldDelegate.shapes;

  void _drawBackground(Canvas canvas, Size size) {
    if (backgroundColor == null) return;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor!,
    );
  }

  void _drawBubble(Canvas canvas, BubbleConfig bubble) {
    final rect = Rect.fromCircle(
      center: Offset(bubble.x, bubble.y),
      radius: bubble.radius,
    );

    if (bubble.shadowBlur != null &&
        bubble.shadowOffset != null &&
        bubble.shadowColor != null) {
      final shadowPath = Path()..addOval(rect.inflate(bubble.shadowBlur!));

      canvas
        ..save()
        ..translate(bubble.shadowOffset!.dx, bubble.shadowOffset!.dy)
        ..drawShadow(shadowPath, bubble.shadowColor!, bubble.shadowBlur!, true)
        ..restore();
    }

    final paint = Paint()
      ..shader = RadialGradient(
        colors: bubble.gradientColors,
        stops: bubble.gradientStops,
        center: Alignment.center,
        radius: 0.8,
      ).createShader(rect)
      ..blendMode = BlendMode.softLight;

    canvas.drawCircle(Offset(bubble.x, bubble.y), bubble.radius, paint);
  }

  void _drawShape(
    Canvas canvas,
    Size size, {
    required ShapeConfig shape,
  }) {
    final path = Path()
      ..moveTo(shape.controlPoints[0].x, shape.controlPoints[0].y);

    if (shape.controlPoints.length == 4) {
      path
        ..quadraticBezierTo(
          shape.controlPoints[1].x,
          shape.controlPoints[1].y,
          shape.controlPoints[2].x,
          shape.controlPoints[2].y,
        )
        ..lineTo(shape.controlPoints[3].x, shape.controlPoints[3].y);
    } else if (shape.controlPoints.length == 3) {
      path.quadraticBezierTo(
        shape.controlPoints[1].x,
        shape.controlPoints[1].y,
        shape.controlPoints[2].x,
        shape.controlPoints[2].y,
      );
    }

    path.close();

    final paint = Paint()..style = PaintingStyle.fill;

    if (shape.gradient != null) {
      paint.shader = shape.gradient!.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      );
    } else if (shape.color != null) {
      paint.color = shape.color!;
    }

    canvas.drawPath(path, paint);
  }
}

class ShapeConfig {
  final List<Point<double>> controlPoints;
  final Color? color;
  final RadialGradient? gradient;

  ShapeConfig({
    required this.controlPoints,
    this.color,
    this.gradient,
  });
}

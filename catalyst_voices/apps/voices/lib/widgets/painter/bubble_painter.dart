import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

typedef PositionCalculator = Offset Function(Size size);
typedef ShapePointCalculator = List<Point<double>> Function(Size size);

class BubbleConfig extends Equatable {
  final PositionCalculator position;
  final double radius;
  final List<Color> gradientColors;
  final List<double> gradientStops;
  final double? shadowBlur;
  final Offset? shadowOffset;
  final Color? shadowColor;

  const BubbleConfig({
    required this.position,
    required this.radius,
    required this.gradientColors,
    required this.gradientStops,
    this.shadowBlur,
    this.shadowOffset,
    this.shadowColor,
  });

  @override
  List<Object?> get props => [
        position,
        radius,
        gradientColors,
        gradientStops,
        shadowBlur,
        shadowOffset,
        shadowColor,
      ];
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
      _drawBubble(canvas, bubble, size);
    }
    for (final shape in shapes) {
      _drawShape(canvas, size, shape: shape);
    }
  }

  @override
  bool shouldRepaint(BubblePainter oldDelegate) =>
      !listEquals(bubbles, oldDelegate.bubbles) ||
      !listEquals(shapes, oldDelegate.shapes);

  void _drawBackground(Canvas canvas, Size size) {
    if (backgroundColor == null) return;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = backgroundColor!,
    );
  }

  void _drawBubble(Canvas canvas, BubbleConfig bubble, Size size) {
    final position = bubble.position(size);
    final rect = Rect.fromCircle(
      center: position,
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

    canvas.drawCircle(position, bubble.radius, paint);
  }

  void _drawShape(
    Canvas canvas,
    Size size, {
    required ShapeConfig shape,
  }) {
    final controlPoints = shape.controlPointsCalculator(size);
    final path = Path()..moveTo(controlPoints[0].x, controlPoints[0].y);

    if (controlPoints.length == 4) {
      path
        ..quadraticBezierTo(
          controlPoints[1].x,
          controlPoints[1].y,
          controlPoints[2].x,
          controlPoints[2].y,
        )
        ..lineTo(controlPoints[3].x, controlPoints[3].y);
    } else if (controlPoints.length == 3) {
      path.quadraticBezierTo(
        controlPoints[1].x,
        controlPoints[1].y,
        controlPoints[2].x,
        controlPoints[2].y,
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

class ShapeConfig extends Equatable {
  final ShapePointCalculator controlPointsCalculator;
  final Color? color;
  final RadialGradient? gradient;

  const ShapeConfig({
    required this.controlPointsCalculator,
    this.color,
    this.gradient,
  });

  @override
  List<Object?> get props => [controlPointsCalculator, color, gradient];
}

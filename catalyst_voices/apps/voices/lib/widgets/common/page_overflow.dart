import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart' show RenderAligningShiftedBox;

// Base on https://gist.github.com/slightfoot/0a573044351c9be9d46ef936c18adb4e
class PageOverflow extends SingleChildRenderObjectWidget {
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;

  const PageOverflow({
    super.key,
    this.width,
    this.height,
    this.alignment = Alignment.topLeft,
    required super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderPageOverflow(
      width: width,
      height: height,
      alignment: alignment,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderPageOverflow renderObject,
  ) {
    renderObject
      ..width = width
      ..height = height
      ..alignment = alignment
      ..textDirection = Directionality.of(context);
  }
}

class RenderPageOverflow extends RenderAligningShiftedBox {
  double? _width;
  double? _height;

  RenderPageOverflow({
    double? width,
    double? height,
    required super.alignment,
    required TextDirection super.textDirection,
    super.child,
  })  : _width = width,
        _height = height;

  double? get height => _height;

  set height(double? value) {
    if (value != _height) {
      _height = value;
      markNeedsLayout();
    }
  }

  double? get width => _width;

  set width(double? value) {
    if (value != _width) {
      _width = value;
      markNeedsLayout();
    }
  }

  @override
  void performLayout() {
    final width = _width ?? constraints.maxWidth;
    final height = _height ?? constraints.maxHeight;
    final childConstraints = constraints
        .copyWith(
          minWidth: width,
          minHeight: height,
        )
        .normalize();
    child!.layout(childConstraints, parentUsesSize: true);
    size = Size(
      constraints.maxWidth,
      math.max(height, child!.size.height),
    );
    alignChild();
  }
}

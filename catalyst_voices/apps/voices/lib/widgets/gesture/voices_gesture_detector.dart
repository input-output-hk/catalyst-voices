import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VoicesGestureDetector extends StatelessWidget {
  /// See [GestureDetector.behavior] and [MouseRegion.hitTestBehavior].
  final HitTestBehavior? behavior;

  /// See [GestureDetector.onTapDown].
  final GestureTapDownCallback? onTapDown;

  /// See [GestureDetector.onTap].
  final VoidCallback? onTap;

  /// See [GestureDetector.onHorizontalDragUpdate].
  final GestureDragUpdateCallback? onHorizontalDragUpdate;

  /// See [GestureDetector.onPanUpdate].
  final GestureDragUpdateCallback? onPanUpdate;

  /// See [GestureDetector.excludeFromSemantics].
  final bool excludeFromSemantics;

  /// See [MouseRegion.onExit].
  final PointerExitEventListener? mouseRegionOnExit;

  /// See [MouseRegion.opaque].
  final bool mouseRegionOpaque;

  /// See [MouseRegion.cursor].
  final MouseCursor cursor;

  final Widget? child;

  const VoicesGestureDetector({
    super.key,
    this.behavior,
    this.onTapDown,
    this.onTap,
    this.onHorizontalDragUpdate,
    this.onPanUpdate,
    this.mouseRegionOnExit,
    this.mouseRegionOpaque = true,
    this.cursor = SystemMouseCursors.click,
    this.excludeFromSemantics = false,
    this.child,
  });

  List<Object?> get _callbacks => [
        onTapDown,
        onTap,
        onHorizontalDragUpdate,
        onPanUpdate,
      ];

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _callbacks.any((element) => element != null)
          ? SystemMouseCursors.click
          : MouseCursor.defer,
      opaque: mouseRegionOpaque,
      hitTestBehavior: behavior,
      onExit: mouseRegionOnExit,
      child: GestureDetector(
        behavior: behavior,
        onTapDown: onTapDown,
        onTap: onTap,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onPanUpdate: onPanUpdate,
        excludeFromSemantics: excludeFromSemantics,
        child: child,
      ),
    );
  }
}

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Usually builds button.
typedef VoicesRawPopupBuilder = Widget Function(
  BuildContext context,
  VoidCallback onTapCallback, {
  required bool isMenuOpen,
});

class VoicesRawPopupMenuButton<T> extends StatefulWidget {
  final VoicesRawPopupBuilder buttonBuilder;
  final WidgetBuilder menuBuilder;
  final ValueChanged<T> onSelected;
  final RouteSettings routeSettings;
  final Offset menuOffset;
  final VoicesRawPopupMenuPosition position;

  const VoicesRawPopupMenuButton({
    super.key,
    required this.buttonBuilder,
    required this.menuBuilder,
    required this.onSelected,
    required this.routeSettings,
    this.menuOffset = const Offset(0, 4),
    this.position = VoicesRawPopupMenuPosition.under,
  });

  @override
  State<VoicesRawPopupMenuButton<T>> createState() => VoicesRawPopupMenuButtonState<T>();
}

class VoicesRawPopupMenuButtonState<T> extends State<VoicesRawPopupMenuButton<T>> {
  bool _isMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return widget.buttonBuilder(
      context,
      showMenu,
      isMenuOpen: _isMenuOpen,
    );
  }

  void hideMenu() {
    if (!_isMenuOpen) return;

    Navigator.of(context, rootNavigator: true)
        .popUntil((route) => route.settings != widget.routeSettings);

    setState(() {
      _isMenuOpen = false;
    });
  }

  void showMenu() {
    if (_isMenuOpen) return;

    setState(() {
      _isMenuOpen = true;
    });

    final navigator = Navigator.of(context, rootNavigator: true);
    final overlayBox = navigator.overlay!.context.findRenderObject()! as RenderBox;

    final buttonBox = context.findRenderObject()! as RenderBox;
    final buttonRect = buttonBox.localToGlobal(Offset.zero, ancestor: overlayBox) & buttonBox.size;

    final route = _VoicesRawPopupMenuStateRoute<T>(
      builder: widget.menuBuilder,
      buttonPosition: buttonRect,
      menuPosition: widget.position,
      offset: widget.menuOffset,
      settings: widget.routeSettings,
    );

    unawaited(
      navigator.push(route).then((value) {
        if (mounted && value != null) {
          widget.onSelected(value);
        }
      }).whenComplete(() {
        if (mounted) {
          setState(() {
            _isMenuOpen = false;
          });
        }
      }),
    );
  }
}

/// Tries to find menu position.
enum VoicesRawPopupMenuPosition {
  /// Menu is positioned over the anchor.
  over,

  /// Menu is positioned under the anchor.
  under,
}

class _VoicesRawPopupMenuStateRoute<T> extends PopupRoute<T> {
  final WidgetBuilder builder;
  final Rect buttonPosition;
  final VoicesRawPopupMenuPosition menuPosition;
  final Offset offset;

  _VoicesRawPopupMenuStateRoute({
    required this.builder,
    required this.buttonPosition,
    required this.menuPosition,
    this.offset = Offset.zero,
    super.settings,
  }) : super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => kThemeAnimationDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: _VoicesRawPopupMenuStateRoutePage(
        buttonPosition: buttonPosition,
        menuPosition: menuPosition,
        offset: offset,
        builder: builder,
      ),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.linear),
      child: child,
    );
  }
}

class _VoicesRawPopupMenuStateRoutePage extends StatelessWidget {
  final Rect buttonPosition;
  final Offset offset;
  final WidgetBuilder builder;
  final VoicesRawPopupMenuPosition menuPosition;

  const _VoicesRawPopupMenuStateRoutePage({
    required this.buttonPosition,
    required this.offset,
    required this.builder,
    required this.menuPosition,
  });

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);

    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: CustomSingleChildLayout(
        delegate: _VoicesRawPopupMenuStateRoutePageLayout(
          buttonPosition: buttonPosition,
          offset: offset,
          textDirection: Directionality.of(context),
          padding: padding,
          menuPosition: menuPosition,
        ),
        child: builder(context),
      ),
    );
  }
}

class _VoicesRawPopupMenuStateRoutePageLayout extends SingleChildLayoutDelegate {
  final Rect buttonPosition;
  final Offset offset;
  final TextDirection textDirection;
  final EdgeInsets padding;
  final VoicesRawPopupMenuPosition menuPosition;

  _VoicesRawPopupMenuStateRoutePageLayout({
    required this.buttonPosition,
    required this.offset,
    this.textDirection = TextDirection.ltr,
    this.padding = EdgeInsets.zero,
    required this.menuPosition,
  });

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) => constraints.loosen();

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final wantedPosition = _findWantedPosition(size, childSize);
    final originCenter = buttonPosition.center;

    final subScreens = DisplayFeatureSubScreen.subScreensInBounds(Offset.zero & size, const []);
    final subScreen = _closestScreen(subScreens, originCenter);
    return _fitInsideScreen(subScreen, childSize, wantedPosition: wantedPosition);
  }

  @override
  bool shouldRelayout(_VoicesRawPopupMenuStateRoutePageLayout oldDelegate) {
    return buttonPosition != oldDelegate.buttonPosition ||
        offset != oldDelegate.offset ||
        textDirection != oldDelegate.textDirection ||
        padding != oldDelegate.padding ||
        menuPosition != oldDelegate.menuPosition;
  }

  Rect _closestScreen(Iterable<Rect> screens, Offset point) {
    var closest = screens.first;
    for (final screen in screens) {
      if ((screen.center - point).distance < (closest.center - point).distance) {
        closest = screen;
      }
    }
    return closest;
  }

  Offset _findWantedPosition(Size size, Size childSize) {
    var x = buttonPosition.left + offset.dx;
    var y = switch (menuPosition) {
          VoicesRawPopupMenuPosition.over => buttonPosition.top,
          VoicesRawPopupMenuPosition.under => buttonPosition.bottom,
        } +
        offset.dy;

    x = math.min(x, size.width);
    y = math.min(y, size.height);

    return Offset(x, y);
  }

  Offset _fitInsideScreen(
    Rect screen,
    Size childSize, {
    required Offset wantedPosition,
  }) {
    var x = wantedPosition.dx;
    var y = wantedPosition.dy;

    if (x < screen.left + padding.left) {
      x = screen.left + padding.left;
    } else if (x + childSize.width > screen.right - padding.right) {
      x = math.max(
        buttonPosition.right - childSize.width,
        screen.left + padding.left,
      );
    }

    if (y < screen.top + padding.top) {
      y = padding.top;
    } else if (y + childSize.height > screen.bottom - padding.bottom) {
      y = screen.bottom - childSize.height - padding.bottom;
    }

    return Offset(x, y);
  }
}

import 'package:flutter/material.dart';

bool _defaultExcludePredicate(Widget child) => false;

typedef ExcludeWidgetPredicate = bool Function(Widget child);

class VoicesWideScreenConstrained extends StatelessWidget {
  /// Width of the screen. Defaults to 1440. When child has padding
  /// of horizontal 120 so actual content is 1200
  final double maxWidth;
  final Color? backgroundColor;
  final Widget child;

  const VoicesWideScreenConstrained({
    super.key,
    this.maxWidth = 1440,
    this.backgroundColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );

    if (backgroundColor != null) {
      content = ColoredBox(
        color: backgroundColor!,
        child: content,
      );
    }

    return content;
  }
}

extension ConstrainedListExtension on List<Widget> {
  List<Widget> constrainedDelegate({
    double maxWidth = 1440,
    ExcludeWidgetPredicate excludePredicate = _defaultExcludePredicate,
  }) {
    return map((widget) {
      if (excludePredicate(widget)) {
        return widget;
      }

      return VoicesWideScreenConstrained(
        maxWidth: maxWidth,
        child: widget,
      );
    }).toList();
  }
}

extension ConstrainedWidgetExtension on Widget {
  Widget withBackground(Color color) {
    return VoicesWideScreenConstrained(
      backgroundColor: color,
      child: this,
    );
  }
}

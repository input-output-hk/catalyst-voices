import 'package:flutter/material.dart';

/// This class acts only as semantic anchor for [show] and its not
/// meant to be extended.
abstract final class VoicesDialog {
  /// Encapsulates single entry point.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    RouteSettings? routeSettings,
    bool barrierDismissible = true,
  }) {
    return showDialog<T>(
      context: context,
      builder: builder,
      routeSettings: routeSettings,
      barrierDismissible: barrierDismissible,
    );
  }
}

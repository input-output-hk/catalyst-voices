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
    return showGeneralDialog<T>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) => builder(context),
      routeSettings: routeSettings,
      barrierDismissible: barrierDismissible,
    );
  }
}

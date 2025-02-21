import 'package:flutter/material.dart';

/// This class acts only as semantic anchor for [show] and its not
/// meant to be extended.
abstract final class VoicesDialog {
  /// Encapsulates single entry point.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    required RouteSettings? routeSettings,
    bool useRootNavigator = true,
    bool barrierDismissible = true,
    Color barrierColor = const Color(0x80000000),
  }) {
    // Similar to showGeneralDialog() but since it requires
    // a barrierLabel we reimplemented the same behavior.
    return Navigator.of(context, rootNavigator: useRootNavigator).push<T>(
      RawDialogRoute<T>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
        barrierDismissible: barrierDismissible,
        barrierColor: barrierColor,
        settings: routeSettings,
      ),
    );
  }
}

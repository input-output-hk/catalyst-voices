import 'package:flutter/material.dart';

/// This class acts only as semantic anchor for [show] and its not
/// meant to be extended.
abstract final class VoicesDialog {
  /// Encapsulates single entry point.
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    return showDialog<T>(
      context: context,
      builder: builder,
    );
  }
}

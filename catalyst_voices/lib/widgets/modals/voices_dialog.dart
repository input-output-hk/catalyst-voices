import 'package:flutter/material.dart';

abstract final class VoicesDialog {
  static Future<T?> show<T>(
    BuildContext context, {
    required WidgetBuilder builder,
  }) {
    return showDialog<T>(
      context: context,
      // TODO(damian): themed value needed
      barrierColor: Color(0x212A3D61).withOpacity(.38),
      builder: builder,
    );
  }
}

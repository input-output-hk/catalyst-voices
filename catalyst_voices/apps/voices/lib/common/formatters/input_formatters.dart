import 'package:flutter/services.dart';

/// Removes any whitespaces.
final class NoWhitespacesFormatter extends FilteringTextInputFormatter {
  NoWhitespacesFormatter() : super.deny(RegExp(r'\s+'));
}

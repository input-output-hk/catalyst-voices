import 'package:flutter/material.dart';

extension TextEditingControllerExt on TextEditingController {
  /// Updates the text in the controller and sets
  /// the cursor position to last index if the text did change.
  set textWithSelection(String newText) {
    final textChanged = text != newText;

    value = value.copyWith(
      text: newText,
      selection: textChanged
          // if the text is already set no need to update the selection
          ? TextSelection.collapsed(offset: newText.length)
          : null,
    );
  }
}

extension TextEditingValueExt on TextEditingValue {
  static TextEditingValue collapsedAtEndOf(String text) {
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

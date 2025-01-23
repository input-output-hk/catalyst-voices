import 'package:flutter/material.dart';

extension TextEditingControllerExt on TextEditingController {
  /// Updates the text in the controller and sets
  /// the cursor position to last index if the text did change.
  set textWithSelection(String newText) {
    final textChanged = text != newText;
    // if the text is already set no need to update the selection
    text = newText;

    if (textChanged) {
      // deliberately using text since newText might be
      // truncated by the text field if there are too many characters
      selection = TextSelection.fromPosition(TextPosition(offset: text.length));
    }
  }
}

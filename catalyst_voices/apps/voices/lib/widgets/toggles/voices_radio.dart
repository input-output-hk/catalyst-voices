import 'package:catalyst_voices/widgets/common/label_decorator.dart';
import 'package:flutter/material.dart';

/// A Voices Radio widget that combines a Radio button with optional
/// label and note text elements.
///
/// Provides a convenient way to create radio buttons with associated
/// information in a visually appealing manner.
class VoicesRadio<T extends Object> extends StatelessWidget {
  /// The value associated with this radio button.
  final T value;

  /// An optional widget to display the label text.
  final Widget? label;

  /// An optional widget to display the note text.
  final Widget? note;

  /// Whether the radio button value can be changed by widget itself.
  final bool toggleable;

  /// Whether the radio button is enabled.
  final bool enabled;

  const VoicesRadio({
    required this.value,
    this.label,
    this.note,
    this.toggleable = false,
    this.enabled = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return LabelDecorator(
      label: label,
      note: note,
      child: Radio(
        key: ValueKey('radio_$value'),
        value: value,
        toggleable: toggleable,
        enabled: enabled,
      ),
    );
  }
}

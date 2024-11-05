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

  /// The current selected value in the radio group.
  final T? groupValue;

  /// Whether the radio button value can be changed by widget itself.
  final bool toggleable;

  /// A callback function that is called when the radio button value changes.
  ///
  /// When null widget is disabled.
  final ValueChanged<T?>? onChanged;

  const VoicesRadio({
    required this.value,
    this.label,
    this.note,
    required this.groupValue,
    this.toggleable = false,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? _changeGroupValue : null,
      behavior: HitTestBehavior.opaque,
      child: LabelDecorator(
        label: label,
        note: note,
        child: Radio(
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          toggleable: toggleable,
        ),
      ),
    );
  }

  void _changeGroupValue() {
    final onChanged = this.onChanged;
    assert(
      onChanged != null,
      'Make sure onChange is not null when using _changeGroupValue',
    );

    if (groupValue == value && toggleable) {
      onChanged!(null);
    }

    if (groupValue != value) {
      onChanged!(value);
    }
  }
}

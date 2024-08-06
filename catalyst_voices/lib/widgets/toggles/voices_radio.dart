import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:collection/collection.dart';
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
    final label = this.label;
    final note = this.note;

    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onChanged != null ? _changeGroupValue : null,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Radio(
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
            toggleable: toggleable,
          ),
          if (label != null)
            DefaultTextStyle(
              style: (theme.textTheme.bodyLarge ?? const TextStyle())
                  .copyWith(color: theme.colors.textPrimary),
              child: label,
            ),
          if (note != null)
            DefaultTextStyle(
              style: (theme.textTheme.bodySmall ?? const TextStyle())
                  .copyWith(color: theme.colors.textOnPrimary),
              child: note,
            ),
        ].expandIndexed(
          (index, element) {
            return [
              if (index == 1) const SizedBox(width: 4),
              if (index == 2) const SizedBox(width: 8),
              element,
            ];
          },
        ).toList(),
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

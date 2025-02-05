import 'package:catalyst_voices/widgets/common/label_decorator.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A checkbox widget with optional label, note, and error state.
///
/// This widget provides a visual representation of a boolean value and allows
/// users to toggle its state. It can display an optional label and note
/// for context, as well as indicate an error state through visual styling.
class VoicesCheckbox extends StatelessWidget {
  /// The current value of the checkbox.
  final bool value;

  /// Callback function invoked when the checkbox value changes.
  ///
  /// The function receives the new value as a parameter.
  ///
  /// When null widget is disabled.
  final ValueChanged<bool>? onChanged;

  /// Indicates whether the checkbox is in an error state.
  final bool isError;

  /// An optional widget to display the label text.
  final Widget? label;

  /// An optional widget to display the note text.
  final Widget? note;

  final bool isDisabled;

  const VoicesCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    this.isError = false,
    this.label,
    this.note,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final onChanged = this.onChanged;

    return AbsorbPointer(
      absorbing: isDisabled,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onChanged != null ? () => onChanged(!value) : null,
          behavior: HitTestBehavior.opaque,
          child: LabelDecorator(
            label: label,
            note: note,
            spacings: const [12, 8],
            child: Checkbox(
              value: value,
              // forcing null unwrapping because we're not allowing null value
              onChanged:
                  onChanged != null ? (value) => onChanged(value!) : null,
              isError: isError,
              side: isDisabled
                  ? BorderSide(
                      width: 2,
                      color: Theme.of(context).colors.onSurfaceNeutral012,
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:catalyst_voices/widgets/toggles/voices_checkbox.dart';
import 'package:flutter/material.dart';

/// Data describing a single checkbox element within a [VoicesCheckboxGroup].
///
/// This class holds information for a single checkbox element displayed
/// within a [VoicesCheckboxGroup].
///
/// Type Parameters:
///
/// * T: The type of the value associated with the checkbox element.
final class VoicesCheckboxGroupElement<T> {
  /// The value associated with the checkbox element.
  final T value;

  /// A widget to display the text label for the checkbox.
  final Widget? label;

  /// An optional widget to display additional information below the label.
  final Widget? note;

  /// A flag indicating if the checkbox represents an error state.
  final bool isError;

  /// Default constructor for [VoicesCheckboxGroupElement].
  ///
  /// Should have at least [label] or [note].
  const VoicesCheckboxGroupElement({
    required this.value,
    this.label,
    this.note,
    this.isError = false,
  }) : assert(
          label != null || note != null,
          'Should have at least label or note',
        );
}

/// A widget that groups a list of checkboxes in a column with a name
/// and the ability to toggle all elements at once.
///
/// This widget displays a group of checkboxes with a shared name. It allows
/// users to select individual checkboxes and provides a master checkbox to
/// toggle all elements on/off simultaneously. You can also optionally specify
/// a callback function to be notified when the selection changes.
///
/// Type Parameters:
///
/// * T: The type of the value associated with each checkbox element.
class VoicesCheckboxGroup<T extends Object> extends StatelessWidget {
  /// The name displayed for the checkbox group.
  final Widget name;

  /// A list of [VoicesCheckboxGroupElement] objects defining each checkbox.
  final List<VoicesCheckboxGroupElement<T>> elements;

  /// A set of currently selected values within the group.
  final Set<T> selected;

  /// An optional callback function to be called when the selection changes.
  final ValueChanged<Set<T>>? onChanged;

  /// How the checkboxes should be aligned horizontally within the group.
  ///
  /// Defaults to [CrossAxisAlignment.start].
  final CrossAxisAlignment crossAxisAlignment;

  bool get _isGroupEnabled => onChanged != null;

  bool get _isGroupSelected =>
      elements.every((element) => selected.contains(element.value));

  const VoicesCheckboxGroup({
    super.key,
    required this.name,
    required this.elements,
    required this.selected,
    this.onChanged,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : assert(elements.length > 0, 'Elements have to be non empty');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        VoicesCheckbox(
          value: _isGroupSelected,
          label: name,
          onChanged: _isGroupEnabled ? _toggleAll : null,
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: crossAxisAlignment,
            children: elements
                .map(
                  (element) {
                    return VoicesCheckbox(
                      value: selected.contains(element.value),
                      label: element.label,
                      note: element.note,
                      onChanged: _isGroupEnabled
                          ? (value) => _updateElement(element.value, value)
                          : null,
                      isError: element.isError,
                    );
                  },
                )
                .expand(
                  (element) => [
                    const SizedBox(height: 16),
                    element,
                  ],
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  void _toggleAll(bool isChecked) {
    assert(
      onChanged != null,
      'Toggled group status but change callback is null',
    );

    final updatedSelection =
        isChecked ? elements.map((e) => e.value).toSet() : <T>{};

    onChanged!(updatedSelection);
  }

  void _updateElement(T value, bool isChecked) {
    assert(
      onChanged != null,
      'Toggled group status but change callback is null',
    );

    final updatedSelection = <T>{...selected};
    if (isChecked) {
      updatedSelection.add(value);
    } else {
      updatedSelection.remove(value);
    }

    onChanged!(updatedSelection);
  }
}

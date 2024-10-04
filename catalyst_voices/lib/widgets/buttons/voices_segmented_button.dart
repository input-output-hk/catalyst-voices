import 'package:flutter/material.dart';

/// Voices SegmentedButton implementation which defaults to flutter M3
/// [SegmentedButton].
///
/// See *catalyst.dart* _buildThemeData for style configuration.
///
/// Be aware [as of flutter 3.22.3]:
///   - when mixing configs of [segments], meaning only some have icons.
///   [SegmentedButton] may incorrectly calculate segment width will cause
///   label to split to multiline. Try avoid when possible.
///
/// Example:
///
/// ```dart
///         VoicesSegmentedButton<int>(
///           segments: [
///             ButtonSegment(value: 0,label: Text('0')),
///             ButtonSegment(value: 1,label: Text('1')),
///             ButtonSegment(value: 2,label: Text('2')),
///             ButtonSegment(value: 3,label: Text('3'))
///           ],
///           selected: _selected,
///           onChanged: (selected) {
///             setState(() {
///               _selected = Set.from(selected);
///             });
///           },
///           showSelectedIcon: false,
///           emptySelectionAllowed: true,
///         ),
/// ```
class VoicesSegmentedButton<T extends Object> extends StatelessWidget {
  /// List of segments that will be shown in button.
  final List<ButtonSegment<T>> segments;

  /// Set of currently selected [segments]. Value corresponds should match
  /// [ButtonSegment.value].
  final Set<T> selected;

  /// Selection change callback.
  final ValueChanged<Set<T>>? onChanged;

  /// Whether user should be allowed to select more then one [segments].
  ///
  /// Results will correspond to [selected].
  final bool multiSelectionEnabled;

  /// Whether user should be allowed to select/unselect [segments] so [selected] is empty.
  ///
  /// Results will correspond to [selected].
  final bool emptySelectionAllowed;

  /// Should insert leading check icon into selected [segments].
  final bool showSelectedIcon;

  /// Customizes this button's appearance.
  final ButtonStyle? style;

  /// Default constructor.
  const VoicesSegmentedButton({
    super.key,
    required this.segments,
    required this.selected,
    this.onChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.showSelectedIcon = true,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: segments,
      selected: selected,
      onSelectionChanged: onChanged,
      multiSelectionEnabled: multiSelectionEnabled,
      emptySelectionAllowed: emptySelectionAllowed,
      showSelectedIcon: showSelectedIcon,
      style: style,
    );
  }
}

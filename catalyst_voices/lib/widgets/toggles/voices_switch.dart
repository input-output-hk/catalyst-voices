import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// A Voices version of a [Switch] widget with optional thumb icon
/// customization.
///
/// This widget provides a basic switch functionality with the ability to
/// display a custom icon on the thumb.
class VoicesSwitch extends StatelessWidget {
  /// The current state of the switch.
  final bool value;

  /// An optional icon to display on the switch thumb.
  final IconData? thumbIcon;

  /// A callback function triggered when the switch value changes.
  final ValueChanged<bool>? onChanged;

  /// Creates a [VoicesSwitch] widget.
  ///
  /// The [value] argument is required and specifies the initial state
  /// of the switch.
  const VoicesSwitch({
    super.key,
    required this.value,
    this.thumbIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final thumbIcon = this.thumbIcon;

    return Switch(
      value: value,
      onChanged: onChanged,
      thumbIcon: thumbIcon != null
          ? WidgetStatePropertyAll(
              Icon(
                thumbIcon,
                color: Theme.of(context).colors.iconsForeground,
              ),
            )
          : null,
    );
  }
}

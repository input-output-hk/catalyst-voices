import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

/// A [RolePicker] widget that is used to display the current visualization
/// role.
class RolePicker extends StatelessWidget {
  final String currentRole;
  final void Function()? onPressed;

  const RolePicker({
    super.key,
    required this.currentRole,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(CatalystVoicesIcons.cheveron_down),
      label: Text(currentRole),
    );
  }
}

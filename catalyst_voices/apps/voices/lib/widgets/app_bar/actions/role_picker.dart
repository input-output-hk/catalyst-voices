import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

/// A [RolePicker] widget that is used to display the current visualization
/// role.
class RolePicker extends StatelessWidget {
  final String currentRole;
  final VoidCallback? onPressed;

  const RolePicker({
    super.key,
    required this.currentRole,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      style: ButtonStyle(
        padding: WidgetStateProperty.all<EdgeInsets>(
          const EdgeInsets.only(left: 24, right: 16),
        ),
      ),
      onPressed: onPressed,
      icon: VoicesAssets.icons.chevronDown.buildIcon(size: 18),
      label: Text(currentRole),
      iconAlignment: IconAlignment.end,
    );
  }
}

import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

/// A [NotificationsIndicator] widget that is used to display pending 
/// notifications.
class NotificationsIndicator extends StatelessWidget {
  final String? badgeText;
  final void Function()? onPressed;

  const NotificationsIndicator({
    super.key,
    this.badgeText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return badgeText != null
        ? Badge(
            label: Text(badgeText!),
            child: _iconButton,
          )
        : _iconButton;
  }

  Widget get _iconButton => IconButton.outlined(
        icon: const Icon(CatalystVoicesIcons.bell),
        onPressed: onPressed,
      );
}

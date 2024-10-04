import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:flutter/material.dart';

/// A [NotificationsIndicator] widget that is used to display pending
/// notifications.
class NotificationsIndicator extends StatelessWidget {
  final String? badgeText;
  final VoidCallback? onPressed;

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
            child: _IconButton(onPressed: onPressed),
          )
        : _IconButton(onPressed: onPressed);
  }
}

class _IconButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const _IconButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      icon: VoicesAssets.icons.bell.buildIcon(),
      onPressed: onPressed,
    );
  }
}

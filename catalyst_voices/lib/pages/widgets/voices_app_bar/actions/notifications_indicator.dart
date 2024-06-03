import 'package:flutter/material.dart';

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
        icon: const Icon(Icons.notifications_none),
        onPressed: onPressed,
      );
}

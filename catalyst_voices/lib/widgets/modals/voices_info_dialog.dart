import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

class VoicesInfoDialog extends StatelessWidget {
  final String title;

  const VoicesInfoDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    // Note. It will be good place to switch to mobile widget.
    return _VoicesDesktopInfoDialog(title: title);
  }
}

class _VoicesDesktopInfoDialog extends StatelessWidget {
  final String title;

  const _VoicesDesktopInfoDialog({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VoicesDesktopPanelsDialog(
      left: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleLarge
                ?.copyWith(color: theme.colors.textOnPrimary),
          ),
        ],
      ),
      right: Column(),
    );
  }
}

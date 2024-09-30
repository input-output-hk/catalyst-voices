import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Opinionated, two panels, dialog that is tailored for desktop
/// form factors.
///
/// Uses [VoicesTwoPaneDialog] for base structure.
///
/// Call [VoicesDialog.show] with [VoicesDesktopInfoDialog] in order
/// to show it.
class VoicesDesktopInfoDialog extends StatelessWidget {
  final Widget title;

  const VoicesDesktopInfoDialog({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return VoicesTwoPaneDialog(
      left: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: theme.textTheme.titleLarge!
                .copyWith(color: theme.colors.textOnPrimary),
            child: title,
          ),
        ],
      ),
      right: const Column(),
    );
  }
}

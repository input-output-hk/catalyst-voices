import 'package:catalyst_voices/widgets/modals/voices_desktop_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:flutter/material.dart';

/// Opinionated, single panel, dialog that is tailored for desktop
/// form factors.
///
/// Uses [VoicesTwoPaneDialog] for base structure.
///
/// Call [VoicesDialog.show] with [VoicesDesktopInfoDialog] in order
/// to show it.
class VoicesDesktopInfoDialog extends StatelessWidget {
  final Widget icon;
  final Widget title;
  final Widget message;
  final Widget? subMessage;
  final Widget action;

  const VoicesDesktopInfoDialog({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.subMessage,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colors;

    final subMessage = this.subMessage;

    final iconThemeData = IconThemeData(
      size: 48,
      color: theme.colorScheme.primary,
    );

    final titleStyle = (textTheme.titleLarge ?? const TextStyle()).copyWith(
      color: colors.textOnPrimaryLevel0,
      fontWeight: FontWeight.bold,
    );

    final messageStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontWeight: subMessage != null ? FontWeight.w700 : null,
      color: colors.textOnPrimaryLevel0,
    );

    final subMessageStyle = (textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w500,
      color: colors.textOnPrimaryLevel0,
    );

    return VoicesSinglePaneDialog(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 83),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 36),
            IconTheme(
              data: iconThemeData,
              child: icon,
            ),
            const SizedBox(height: 8),
            DefaultTextStyle(
              style: titleStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: title,
            ),
            const SizedBox(height: 24),
            DefaultTextStyle(
              style: messageStyle,
              textAlign: TextAlign.center,
              child: message,
            ),
            if (subMessage != null) ...[
              const SizedBox(height: 15),
              DefaultTextStyle(
                style: subMessageStyle,
                textAlign: TextAlign.center,
                child: subMessage,
              ),
            ],
            const SizedBox(height: 24),
            action,
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

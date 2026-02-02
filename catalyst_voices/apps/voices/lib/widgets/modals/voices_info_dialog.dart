import 'package:catalyst_voices/widgets/modals/voices_dialog.dart';
import 'package:catalyst_voices/widgets/modals/voices_panel_dialog.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';

/// Opinionated, single panel, dialog that adapts to current form factor.
///
/// Call [VoicesDialog.show] with [VoicesInfoDialog] in order to show it.
class VoicesInfoDialog extends StatelessWidget {
  final IconThemeData? iconThemeData;
  final Widget? icon;
  final Widget title;
  final Widget message;
  final Widget? subMessage;
  final Widget? action;

  const VoicesInfoDialog({
    super.key,
    this.iconThemeData,
    this.icon,
    required this.title,
    required this.message,
    this.subMessage,
    this.action,
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
    ).merge(this.iconThemeData);

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

    return VoicesPanelDialog(
      child: ResponsiveBuilder<EdgeInsets>(
        xs: const EdgeInsets.symmetric(horizontal: 24),
        sm: const EdgeInsets.symmetric(horizontal: 83),
        builder: (context, padding) {
          return SingleChildScrollView(
            padding: padding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 36),
                if (icon case final icon?) ...[
                  IconTheme(
                    data: iconThemeData,
                    child: icon,
                  ),
                  const SizedBox(height: 8),
                ],
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
                if (action case final action?) ...[
                  const SizedBox(height: 24),
                  action,
                ],
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }
}

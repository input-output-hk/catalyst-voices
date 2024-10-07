import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class RegistrationExitConfirmDialog extends StatelessWidget {
  const RegistrationExitConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return VoicesQuestionDialog(
      title: Text(l10n.warning.toUpperCase()),
      icon: const _WarningIcon(),
      subtitle: Text(l10n.registrationExitConfirmDialogSubtitle.toUpperCase()),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Text(l10n.registrationExitConfirmDialogContent),
      ),
      actions: [
        VoicesQuestionActionItem.negative(
          l10n.registrationExitConfirmDialogContinue,
          type: VoicesQuestionActionType.filled,
        ),
        VoicesQuestionActionItem.positive(
          l10n.registrationExitConfirmDialogCancel,
          type: VoicesQuestionActionType.text,
        ),
      ],
    );
  }
}

class _WarningIcon extends StatelessWidget {
  const _WarningIcon();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.colors.iconsError!;

    return VoicesAvatar(
      border: Border.all(
        color: color,
        width: 3,
      ),
      icon: VoicesAssets.icons.exclamation.buildIcon(size: 36),
      backgroundColor: Colors.transparent,
      foregroundColor: color,
      radius: 40,
    );
  }
}

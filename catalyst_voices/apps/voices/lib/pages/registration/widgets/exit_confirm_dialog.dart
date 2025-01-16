import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class RecoveryExitConfirmDialog extends StatelessWidget {
  const RecoveryExitConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ExitConfirmDialog(
      title: context.l10n.warning,
      subtitle: context.l10n.recoveryExitConfirmDialogSubtitle,
      content: context.l10n.recoveryExitConfirmDialogContent,
      positive: context.l10n.recoveryExitConfirmDialogContinue,
      negative: context.l10n.cancelAnyways,
    );
  }
}

class RegistrationExitConfirmDialog extends StatelessWidget {
  const RegistrationExitConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return ExitConfirmDialog(
      title: context.l10n.warning,
      subtitle: context.l10n.registrationExitConfirmDialogSubtitle,
      content: context.l10n.registrationExitConfirmDialogContent,
      positive: context.l10n.registrationExitConfirmDialogContinue,
      negative: context.l10n.cancelAnyways,
    );
  }
}

class ExitConfirmDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String content;
  final String positive;
  final String negative;

  const ExitConfirmDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.positive,
    required this.negative,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesQuestionDialog(
      title: Text(title.toUpperCase()),
      icon: const _WarningIcon(),
      subtitle: Text(subtitle.toUpperCase()),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: Text(content),
      ),
      actions: [
        VoicesQuestionActionItem.negative(
          positive,
          type: VoicesQuestionActionType.filled,
        ),
        VoicesQuestionActionItem.positive(
          negative,
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
    final color = theme.colors.iconsError;

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

import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

class RecoveryExitConfirmDialog extends StatelessWidget {
  const RecoveryExitConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationConfirmDialog(
      title: context.l10n.warning,
      subtitle: context.l10n.recoveryExitConfirmDialogSubtitle,
      content: Text(
        key: const Key('RecoveryExitDialogContent'),
        context.l10n.recoveryExitConfirmDialogContent,
      ),
      negativeText: context.l10n.cancelAnyways,
      positiveText: context.l10n.recoveryExitConfirmDialogContinue,
    );
  }
}

class RegistrationConfirmDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget content;
  final String negativeText;
  final String positiveText;

  const RegistrationConfirmDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    required this.negativeText,
    required this.positiveText,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesQuestionDialog(
      title: Text(
        key: const Key('RegistrationDialogTitle'),
        title.toUpperCase(),
      ),
      icon: const _WarningIcon(),
      subtitle: Text(subtitle.toUpperCase()),
      content: Padding(
        padding: const EdgeInsets.only(bottom: 30),
        child: content,
      ),
      actions: [
        VoicesQuestionActionItem.positive(
          positiveText,
          type: VoicesQuestionActionType.filled,
        ),
        VoicesQuestionActionItem.negative(
          negativeText,
          type: VoicesQuestionActionType.text,
        ),
      ],
    );
  }
}

class RegistrationExitConfirmDialog extends StatelessWidget {
  const RegistrationExitConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationConfirmDialog(
      title: context.l10n.warning,
      subtitle: context.l10n.registrationExitConfirmDialogSubtitle,
      content: Text(
        key: const Key('RegistrationExitDialogContent'),
        context.l10n.registrationExitConfirmDialogContent,
      ),
      negativeText: context.l10n.cancelAnyways,
      positiveText: context.l10n.registrationExitConfirmDialogContinue,
    );
  }
}

class WalletLinkExitConfirmDialog extends StatelessWidget {
  const WalletLinkExitConfirmDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return RegistrationConfirmDialog(
      title: context.l10n.warning,
      subtitle: context.l10n.walletLinkExitConfirmDialogSubtitle,
      content: Text(
        key: const Key('RegistrationExitDialogContent'),
        context.l10n.walletLinkExitConfirmDialogContent,
      ),
      negativeText: context.l10n.cancelAnyways,
      positiveText: context.l10n.walletLinkExitConfirmDialogContinue,
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
      key: const Key('WarningIcon'),
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

import 'package:catalyst_voices/pages/proposal_builder/dialog/proposal_builder_dialog_widgets.dart';
import 'package:catalyst_voices/widgets/painter/arrow_right_painter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:flutter/material.dart';

/// A dialog for submitting a proposal into review.
class SubmitProposalForReviewDialog extends StatefulWidget {
  final String proposalTitle;
  final String currentVersion;
  final String nextVersion;

  const SubmitProposalForReviewDialog({
    super.key,
    required this.proposalTitle,
    required this.currentVersion,
    required this.nextVersion,
  });

  @override
  State<SubmitProposalForReviewDialog> createState() =>
      _SubmitProposalForReviewDialogState();

  /// Shows a dialog and returns a [Future] that resolves to `true`
  /// if the user wants to submit the proposal for review
  /// or `false` or `null` if not.
  static Future<bool?> show({
    required BuildContext context,
    required String proposalTitle,
    required String currentVersion,
    required String nextVersion,
  }) {
    return VoicesDialog.show(
      context: context,
      routeSettings: const RouteSettings(name: '/submit-proposal-for-review'),
      builder: (context) => SubmitProposalForReviewDialog(
        proposalTitle: proposalTitle,
        currentVersion: currentVersion,
        nextVersion: nextVersion,
      ),
      barrierDismissible: false,
    );
  }
}

class _AgreementConfirmation extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const _AgreementConfirmation({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => onChanged(!value),
          child: Row(
            spacing: 24,
            children: [
              VoicesCheckbox(
                value: value,
                onChanged: onChanged,
              ),
              Expanded(
                child: Text(
                  context.l10n.publishProposalForReviewDialogAgreement,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Arrow extends StatelessWidget {
  const _Arrow();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 24),
      painter: ArrowRightPainter(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final bool submitEnabled;

  const _Buttons({required this.submitEnabled});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        spacing: 16,
        children: [
          VoicesTextButton(
            onTap: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.cancelButtonText),
          ),
          VoicesTextButton(
            onTap: submitEnabled ? () => Navigator.of(context).pop(true) : null,
            child: Text(context.l10n.submitButtonText),
          ),
        ],
      ),
    );
  }
}

class _ListItems extends StatelessWidget {
  const _ListItems();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 8,
        children: [
          ProposalPublishDialogListItem(
            icon: VoicesAssets.icons.eye,
            text: context.l10n.publishProposalForReviewDialogList1,
          ),
          ProposalPublishDialogListItem(
            icon: VoicesAssets.icons.chatAlt2,
            text: context.l10n.publishProposalForReviewDialogList2,
          ),
          ProposalPublishDialogListItem(
            icon: VoicesAssets.icons.exclamationCircle,
            text: context.l10n.publishProposalForReviewDialogList3,
          ),
        ],
      ),
    );
  }
}

class _SubmitProposalForReviewDialogState
    extends State<SubmitProposalForReviewDialog> {
  bool _agreementConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return VoicesSinglePaneDialog(
      constraints: const BoxConstraints(
        minWidth: 450,
        maxWidth: 450,
        minHeight: 256,
      ),
      showClose: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          ProposalPublishDialogHeader(
            title: context.l10n.publishProposalForReviewDialogTitle,
            subtitle: context.l10n.publishProposalForReviewDialogSubtitle,
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 28),
          _VersionUpdateSection(
            proposalTitle: widget.proposalTitle,
            currentVersion: widget.currentVersion,
            nextVersion: widget.nextVersion,
          ),
          const SizedBox(height: 28),
          const Divider(),
          const SizedBox(height: 8),
          const _ListItems(),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 20),
          _AgreementConfirmation(
            value: _agreementConfirmed,
            onChanged: _onAgreementConfirmationChanged,
          ),
          const SizedBox(height: 16),
          _Buttons(submitEnabled: _agreementConfirmed),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _onAgreementConfirmationChanged(bool value) {
    setState(() {
      _agreementConfirmed = value;
    });
  }
}

class _VersionChip extends StatelessWidget {
  final String version;

  const _VersionChip({
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Row(
        spacing: 6,
        children: [
          VoicesAssets.icons.documentText.buildIcon(size: 18),
          Text(
            version,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colors.textOnPrimaryLevel1,
                ),
          ),
        ],
      ),
    );
  }
}

class _VersionUpdate extends StatelessWidget {
  final String current;
  final String next;

  const _VersionUpdate({
    required this.current,
    required this.next,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ProposalPublishDialogDraftChip(),
        const SizedBox(width: 4),
        _VersionChip(version: current),
        const SizedBox(width: 16),
        const Expanded(child: _Arrow()),
        const SizedBox(width: 16),
        const ProposalPublishDialogFinalChip(),
        const SizedBox(width: 4),
        _VersionChip(version: next),
      ],
    );
  }
}

class _VersionUpdateSection extends StatelessWidget {
  final String proposalTitle;
  final String currentVersion;
  final String nextVersion;

  const _VersionUpdateSection({
    required this.proposalTitle,
    required this.currentVersion,
    required this.nextVersion,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.change,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            proposalTitle,
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _VersionUpdate(
            current: currentVersion,
            next: nextVersion,
          ),
        ],
      ),
    );
  }
}

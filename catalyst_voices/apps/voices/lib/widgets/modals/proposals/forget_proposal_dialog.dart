import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/widgets/cards/proposal_card_widgets.dart';
import 'package:catalyst_voices/widgets/common/affix_decorator.dart';
import 'package:catalyst_voices/widgets/painter/arrow_right_painter.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class ForgetProposalDialog extends StatefulWidget {
  final String title;
  final int version;
  final ProposalPublish publish;
  const ForgetProposalDialog({
    super.key,
    required this.title,
    required this.version,
    required this.publish,
  });

  @override
  State<ForgetProposalDialog> createState() => _ForgetProposalDialogState();

  static Future<ProposalForgetActions?> show({
    required BuildContext context,
    required String title,
    required int version,
    required ProposalPublish publish,
  }) {
    return VoicesDialog.show(
      context: context,
      builder: (context) => ForgetProposalDialog(
        title: title,
        version: version,
        publish: publish,
      ),
      routeSettings: const RouteSettings(name: '/unlock-edit-proposal'),
      barrierDismissible: false,
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final bool agreement;
  const _ActionButtons({
    required this.agreement,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          VoicesTextButton(
            onTap: () {
              Navigator.of(context).pop(const ExportProposalForgetAction());
            },
            child: Text(
              context.l10n.exportButtonText,
            ),
          ),
          const Spacer(),
          VoicesTextButton(
            onTap: () {
              Navigator.of(context).pop(null);
            },
            child: Text(
              context.l10n.cancelButtonText,
            ),
          ),
          VoicesTextButton(
            onTap: agreement
                ? () {
                    Navigator.of(context)
                        .pop(const ForgetProposalForgetAction());
                  }
                : null,
            child: Text(
              context.l10n.forgetProposal,
            ),
          ),
        ],
      ),
    );
  }
}

class _Agreement extends StatelessWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;

  const _Agreement({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: VoicesCheckbox(
        value: value,
        onChanged: onChanged,
        label: Text(
          context.l10n.forgetProposalAgreement,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
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
        color: Theme.of(context).colors.textOnPrimaryLevel1,
      ),
    );
  }
}

class _CautionInfo extends StatelessWidget {
  const _CautionInfo();

  @override
  Widget build(BuildContext context) {
    return Text(
      context.l10n.forgetProposalDialogDescription,
      style: context.textTheme.bodyMedium?.copyWith(
        color: context.colors.textOnPrimaryLevel1,
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const VoicesDivider(
      height: 32,
      indent: 0,
      endIndent: 0,
    );
  }
}

class _ForgetProposalDialogState extends State<ForgetProposalDialog> {
  bool agreement = false;
  @override
  Widget build(BuildContext context) {
    const padding = EdgeInsets.symmetric(horizontal: 24);
    return VoicesSinglePaneDialog(
      constraints: const BoxConstraints(maxWidth: 450, maxHeight: 576),
      showClose: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Header(),
          const Padding(
            padding: padding,
            child: _CautionInfo(),
          ),
          const _Divider(),
          Padding(
            padding: padding,
            child: _VersionUnlock(
              version: widget.version.toString(),
              title: widget.title,
              publish: widget.publish,
            ),
          ),
          const _Divider(),
          const _Warnings(),
          const _Divider(),
          _Agreement(
            value: agreement,
            onChanged: _agreementChanged,
          ),
          const Spacer(),
          _ActionButtons(
            agreement: agreement,
          ),
        ],
      ),
    );
  }

  void _agreementChanged(bool value) {
    setState(() {
      agreement = value;
    });
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      child: Text(
        context.l10n.forgetProposal,
        style: context.textTheme.headlineSmall,
      ),
    );
  }
}

class _VersionUnlock extends StatelessWidget {
  final String version;
  final String title;
  final ProposalPublish publish;
  const _VersionUnlock({
    required this.version,
    required this.title,
    required this.publish,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          context.l10n.change,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colors.textOnPrimaryLevel1,
          ),
        ),
        Text(
          title,
          style: context.textTheme.titleSmall,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (publish.isPublished) const FinalProposalChip(),
            if (publish.isDraft) const DraftProposalChip(),
            const SizedBox(width: 4),
            ProposalVersionChip(version: version),
            const SizedBox(width: 16),
            const Expanded(child: _Arrow()),
            const SizedBox(width: 16),
            VoicesChip.rectangular(
              content: Text(context.l10n.forgetProposal),
            ),
          ],
        ),
        const SizedBox(height: 14),
      ],
    );
  }
}

class _Warnings extends StatelessWidget {
  const _Warnings();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AffixDecorator(
            prefix: VoicesAssets.icons.exclamation.buildIcon(),
            gap: 24,
            child: Text(
              context.l10n.forgetProposalCantEditWarning,
            ),
          ),
          const SizedBox(height: 16),
          AffixDecorator(
            prefix: VoicesAssets.icons.documentText.buildIcon(),
            gap: 24,
            child: Text(
              context.l10n.forgetProposalCantGetFundingWarning,
            ),
          ),
          const SizedBox(height: 16),
          AffixDecorator(
            prefix: VoicesAssets.icons.eyeOff.buildIcon(),
            gap: 24,
            child: Text(
              context.l10n.forgetProposalInvisibleWarning,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

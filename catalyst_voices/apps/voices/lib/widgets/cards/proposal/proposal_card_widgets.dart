import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/common/ext/proposal_publish_ext.dart';
import 'package:catalyst_voices/widgets/chips/voices_chip.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/material.dart';

class DraftProposalChip extends StatelessWidget {
  const DraftProposalChip({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Text(
        context.l10n.draft,
        key: const Key('ProposalStage'),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      backgroundColor: Theme.of(context).colors.iconsSecondary,
    );
  }
}

class FinalProposalChip extends StatelessWidget {
  final bool onColorBackground;

  const FinalProposalChip({super.key, this.onColorBackground = true});

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Text(
        context.l10n.finalProposal,
        key: const Key('ProposalStage'),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      backgroundColor: onColorBackground ? Theme.of(context).colorScheme.primary : null,
    );
  }
}

class PrivateProposalChip extends StatelessWidget {
  const PrivateProposalChip({super.key});

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Text(
        context.l10n.private,
        key: const Key('ProposalStage'),
        style: TextStyle(
          color: Theme.of(context).colors.textOnPrimaryLevel1,
        ),
      ),
      backgroundColor: Theme.of(context).colors.elevationsOnSurfaceNeutralLv1Grey,
    );
  }
}

class ProposalCommentsChip extends StatelessWidget {
  final int commentsCount;
  final Color? foregroundColor;
  final Color? backgroundColor;

  const ProposalCommentsChip({
    super.key,
    required this.commentsCount,
    this.foregroundColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      backgroundColor: backgroundColor,
      leading: VoicesAssets.icons.chatAlt2.buildIcon(
        color: foregroundColor,
      ),
      content: Text(
        key: const Key('CommentsCount'),
        commentsCount.toString(),
        style: context.textTheme.labelLarge?.copyWith(
          color: foregroundColor,
        ),
      ),
    );
  }
}

class ProposalIterationStageChip extends StatelessWidget {
  final ProposalPublish status;
  final int versionNumber;
  final bool useInternalBackground;

  const ProposalIterationStageChip({
    super.key,
    required this.status,
    required this.versionNumber,
    this.useInternalBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      leading: status.workspaceIcon.buildIcon(
        color: useInternalBackground ? null : context.colors.iconsBackground,
      ),
      content: Text(
        context.l10n.proposalStageAndIteration(
          status.localizedWorkspaceName(context.l10n),
          versionNumber,
        ),
        style: context.textTheme.labelLarge?.copyWith(
          color: useInternalBackground
              ? Theme.of(context).colors.textOnPrimaryLevel1
              : context.colors.iconsBackground,
        ),
      ),
    );
  }
}

class ProposalPublishChip extends StatelessWidget {
  final ProposalPublish proposalPublish;

  const ProposalPublishChip({
    super.key,
    required this.proposalPublish,
  });

  @override
  Widget build(BuildContext context) {
    return switch (proposalPublish) {
      ProposalPublish.localDraft => const PrivateProposalChip(),
      ProposalPublish.publishedDraft => const DraftProposalChip(),
      ProposalPublish.submittedProposal => const FinalProposalChip(),
    };
  }
}

class ProposalVersionChip extends StatelessWidget {
  final String version;
  final bool useInternalBackground;

  const ProposalVersionChip({
    super.key,
    required this.version,
    this.useInternalBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Row(
        spacing: 6,
        children: [
          VoicesAssets.icons.documentText.buildIcon(
            size: 18,
            color: useInternalBackground ? null : context.colors.iconsBackground,
          ),
          Text(
            version,
            key: const Key('Version'),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: useInternalBackground
                  ? Theme.of(context).colors.textOnPrimaryLevel1
                  : context.colors.iconsBackground,
            ),
          ),
        ],
      ),
    );
  }
}

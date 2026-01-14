import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_collaborators.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalApprovalFinalCard extends StatelessWidget {
  final UsersProposalOverview proposal;
  final CatalystId? activeAccountId;

  const ProposalApprovalFinalCard({
    super.key,
    required this.proposal,
    required this.activeAccountId,
  });

  @override
  Widget build(BuildContext context) {
    final contributors = proposal.contributors;

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: context.colors.elevationsOnSurfaceNeutralLv1White,
        boxShadow: [
          BoxShadow(
            color: context.colors.onSurfaceNeutral016,
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(proposal: proposal),
          if (contributors.isNotEmpty)
            ProposalApprovalContributors(
              contributors: contributors,
              tab: ProposalApprovalTabType.finalProposals,
              activeAccountId: activeAccountId,
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final UsersProposalOverview proposal;

  const _Header({required this.proposal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.primary,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.l10n.fundXAbbr(proposal.fundNumber)}: ${proposal.category}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colors.primaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            proposal.title,
            style: theme.textTheme.titleSmall?.copyWith(color: theme.colors.textOnPrimaryWhite),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const _ProposalStatusChip(),
              const SizedBox(width: 4),
              ProposalVersionChip(
                version: '${proposal.versions.latest.versionNumber}',
                foregroundColor: context.colors.iconsBackground,
              ),
              const SizedBox(width: 10),
              Text(
                DateFormatter.formatDayMonthTime(proposal.updateDate),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colors.textOnPrimaryWhite,
                ),
              ),
              const Spacer(),
              ProposalCommentsChip(
                commentsCount: proposal.commentsCount,
                foregroundColor: theme.colors.iconsBackground,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProposalStatusChip extends StatelessWidget {
  const _ProposalStatusChip();

  @override
  Widget build(BuildContext context) {
    return VoicesChip.rectangular(
      content: Row(
        spacing: 6,
        children: [
          VoicesAssets.icons.lockClosed.buildIcon(
            size: 18,
            color: context.colors.iconsBackground,
          ),
          Text(
            context.l10n.finalProposal,
            key: const Key('ProposalStatus'),
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: context.colors.textOnPrimaryWhite,
            ),
          ),
        ],
      ),
    );
  }
}

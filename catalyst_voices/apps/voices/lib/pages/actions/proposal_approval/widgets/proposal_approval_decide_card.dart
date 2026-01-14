import 'dart:async';

import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/actions/proposal_approval/widgets/proposal_approval_collaborators.dart';
import 'package:catalyst_voices/routes/routing/proposal_builder_route.dart';
import 'package:catalyst_voices/widgets/widgets.dart';
import 'package:catalyst_voices_assets/catalyst_voices_assets.dart';
import 'package:catalyst_voices_brands/catalyst_voices_brands.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class ProposalApprovalDecideCard extends StatelessWidget {
  final UsersProposalOverview proposal;
  final CatalystId? activeAccountId;

  const ProposalApprovalDecideCard({
    super.key,
    required this.proposal,
    required this.activeAccountId,
  });

  @override
  Widget build(BuildContext context) {
    final contributors = proposal.contributors;

    return DecoratedBox(
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
          const Divider(),
          if (contributors.isNotEmpty) ...[
            ProposalApprovalContributors(
              contributors: contributors,
              tab: ProposalApprovalTabType.decide,
              activeAccountId: activeAccountId,
            ),
            const Divider(),
          ],
          _Footer(proposalId: proposal.id),
        ],
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final DocumentRef proposalId;

  const _Footer({required this.proposalId});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: VoicesFilledButton(
        leading: VoicesAssets.icons.plus.buildIcon(),
        child: Text(context.l10n.openForDecision),
        onTap: () => unawaited(ProposalBuilderRoute.fromRef(ref: proposalId).push(context)),
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
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.l10n.fundXAbbr(proposal.fundNumber)}: ${proposal.category}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colors.textOnPrimaryLevel1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            proposal.title,
            style: theme.textTheme.titleSmall,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const _ProposalStatusChip(),
              const SizedBox(width: 4),
              ProposalVersionChip(version: '${proposal.versions.latest.versionNumber}'),
              const SizedBox(width: 10),
              Text(
                DateFormatter.formatDayMonthTime(proposal.updateDate),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colors.textOnPrimaryLevel1,
                ),
              ),
              const Spacer(),
              ProposalCommentsChip(commentsCount: proposal.commentsCount),
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
      content: Text(
        context.l10n.candidateFinalProposal,
        key: const Key('ProposalStatus'),
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }
}

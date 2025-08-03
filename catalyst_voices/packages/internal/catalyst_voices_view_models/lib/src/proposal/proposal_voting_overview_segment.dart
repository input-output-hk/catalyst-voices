import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

sealed class ProposalVotingOverviewSection extends BaseSection {
  const ProposalVotingOverviewSection({
    required super.id,
  });
}

final class ProposalVotingOverviewSegment extends BaseSegment<ProposalVotingOverviewSection> {
  const ProposalVotingOverviewSegment({
    required super.id,
    required super.sections,
  });

  ProposalVotingOverviewSegment.build({
    required ProposalViewVoting data,
  }) : super(
          id: const NodeId('voting_overview'),
          sections: [
            ProposalVotingStatusSection(
              id: const NodeId('voting_overview.status'),
              data: data,
            ),
          ],
        );

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.votingOverview;
  }
}

final class ProposalVotingStatusSection extends ProposalVotingOverviewSection {
  final ProposalViewVoting data;

  const ProposalVotingStatusSection({
    required super.id,
    required this.data,
  });

  @override
  String resolveTitle(BuildContext context) {
    return context.l10n.votingStatus;
  }
}

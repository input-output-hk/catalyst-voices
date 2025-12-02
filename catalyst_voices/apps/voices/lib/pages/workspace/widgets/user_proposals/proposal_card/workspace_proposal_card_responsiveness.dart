part of 'workspace_proposal_card.dart';

class _LargeScreen extends StatelessWidget {
  final UsersProposalOverview proposal;
  final bool isSubmitted;
  final WorkspaceProposalType type;

  const _LargeScreen({
    required this.proposal,
    required this.isSubmitted,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 20,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints.tightFor(width: 730),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _BodyHeader(
                title: proposal.title,
                lastUpdate: proposal.updateDate,
                ownership: proposal.ownership,
              ),
              ProposalIterationStageChip(
                status: proposal.publish,
                versionNumber: proposal.iteration,
                useInternalBackground: !isSubmitted,
              ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 30,
          children: [
            SizedBox(
              width: 260,
              child: _CampaignData(
                leadValue: proposal.category,
                subValue: context.l10n.fundNoCategory(proposal.fundNumber),
              ),
            ),
            _CampaignData(
              leadValue: MoneyFormatter.formatDecimal(proposal.fundsRequested),
              subValue: context.l10n.proposalViewFundingRequested,
            ),
            if (!type.isInvite)
              _CampaignData(
                leadValue: proposal.commentsCount == 0
                    ? context.l10n.notAvailableAbbr
                    : proposal.commentsCount.toString(),
                subValue: context.l10n.comments(proposal.commentsCount),
              ),
          ],
        ),
        // This allows to center previous row
        const SizedBox.shrink(),
      ],
    );
  }
}

class _MediumScreen extends StatelessWidget {
  final UsersProposalOverview proposal;
  final bool isSubmitted;
  final WorkspaceProposalType type;

  const _MediumScreen({
    required this.proposal,
    required this.isSubmitted,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _BodyHeader(
              title: proposal.title,
              lastUpdate: proposal.updateDate,
              ownership: proposal.ownership,
            ),
            ProposalIterationStageChip(
              status: proposal.publish,
              versionNumber: proposal.iteration,
              useInternalBackground: !isSubmitted,
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: 30,
          runSpacing: 10,
          children: [
            SizedBox(
              width: 260,
              child: _CampaignData(
                leadValue: proposal.category,
                subValue: context.l10n.fundNoCategory(proposal.fundNumber),
              ),
            ),
            _CampaignData(
              leadValue: MoneyFormatter.formatDecimal(proposal.fundsRequested),
              subValue: context.l10n.proposalViewFundingRequested,
            ),
            if (!type.isInvite)
              _CampaignData(
                leadValue: proposal.commentsCount == 0
                    ? context.l10n.notAvailableAbbr
                    : proposal.commentsCount.toString(),
                subValue: context.l10n.comments(proposal.commentsCount),
              ),
          ],
        ),
      ],
    );
  }
}

class _SmallScreen extends StatelessWidget {
  final UsersProposalOverview proposal;
  final bool isSubmitted;
  final WorkspaceProposalType type;

  const _SmallScreen({
    required this.proposal,
    required this.isSubmitted,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 10,
      children: [
        _BodyHeader(
          title: proposal.title,
          lastUpdate: proposal.updateDate,
          ownership: proposal.ownership,
        ),
        ProposalIterationStageChip(
          status: proposal.publish,
          versionNumber: proposal.iteration,
          useInternalBackground: !isSubmitted,
        ),
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          runSpacing: 10,
          spacing: 30,
          children: [
            SizedBox(
              width: 260,
              child: _CampaignData(
                leadValue: proposal.category,
                subValue: context.l10n.fundNoCategory(proposal.fundNumber),
              ),
            ),
            _CampaignData(
              leadValue: MoneyFormatter.formatDecimal(proposal.fundsRequested),
              subValue: context.l10n.proposalViewFundingRequested,
            ),
            if (!type.isInvite)
              _CampaignData(
                leadValue: proposal.commentsCount == 0
                    ? context.l10n.notAvailableAbbr
                    : proposal.commentsCount.toString(),
                subValue: context.l10n.comments(proposal.commentsCount),
              ),
          ],
        ),
      ],
    );
  }
}

class _WorkspaceProposalCardResponsiveness extends StatelessWidget {
  final UsersProposalOverview proposal;
  final WorkspaceProposalType type;

  const _WorkspaceProposalCardResponsiveness(this.proposal, {required this.type});

  @override
  Widget build(BuildContext context) {
    final isSubmitted = _ProposalSubmitState.of(context)?.isSubmitted ?? false;
    return ResponsiveChildBuilder(
      sm: (_) => _SmallScreen(
        proposal: proposal,
        isSubmitted: isSubmitted,
        type: type,
      ),
      md: (_) => _MediumScreen(
        proposal: proposal,
        isSubmitted: isSubmitted,
        type: type,
      ),
      lg: (_) => _LargeScreen(
        proposal: proposal,
        isSubmitted: isSubmitted,
        type: type,
      ),
    );
  }
}

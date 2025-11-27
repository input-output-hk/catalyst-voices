import 'package:catalyst_voices/common/ext/build_context_ext.dart';
import 'package:catalyst_voices/pages/workspace/proposal_menu_action_button.dart';
import 'package:catalyst_voices/widgets/cards/proposal/proposal_card_widgets.dart';
import 'package:catalyst_voices/widgets/cards/proposal_iteration_history_card.dart';
import 'package:catalyst_voices/widgets/text/last_edit_date.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter/material.dart';

class WorkspaceProposalCard extends StatelessWidget {
  final UsersProposalOverview proposal;

  const WorkspaceProposalCard({
    super.key,
    required this.proposal,
  });

  @override
  Widget build(BuildContext context) {
    final isSubmitted = proposal.publish.isPublished;
    final isLocalDraft = proposal.publish.isLocal;

    return _ProposalSubmitState(
      isSubmitted: isSubmitted,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSubmitted
                ? context.colors.iconsPrimary
                : context.colors.elevationsOnSurfaceNeutralLv1White,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            spacing: 12,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Body(proposal),
              Offstage(
                offstage: isSubmitted || isLocalDraft || proposal.versions.length < 2,
                child: ProposalIterationHistory(
                  proposal: proposal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final UsersProposalOverview proposal;

  const _Body(this.proposal);

  @override
  Widget build(BuildContext context) {
    final isSubmitted = _ProposalSubmitState.of(context)?.isSubmitted ?? false;
    final commentsCount = proposal.commentsCount;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 50,
            runSpacing: 20,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 750),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _BodyHeader(
                      title: proposal.title,
                      lastUpdate: proposal.updateDate,
                    ),
                    ProposalIterationStageChip(
                      status: proposal.publish,
                      versionNumber: proposal.iteration,
                      useInternalBackground: !isSubmitted,
                    ),
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 630),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 300,
                      child: _CampaignData(
                        leadValue: proposal.category,
                        subValue: context.l10n.fundNoCategory(proposal.fundNumber),
                      ),
                    ),
                    _CampaignData(
                      leadValue: MoneyFormatter.formatDecimal(proposal.fundsRequested),
                      subValue: context.l10n.proposalViewFundingRequested,
                    ),
                    _CampaignData(
                      leadValue: commentsCount == 0
                          ? context.l10n.notAvailableAbbr
                          : commentsCount.toString(),
                      subValue: context.l10n.comments(commentsCount),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        ProposalMenuActionButton(
          ref: proposal.id,
          proposalPublish: proposal.publish,
          title: proposal.title,
          version: proposal.iteration,
          hasNewerLocalIteration: proposal.hasNewerLocalIteration,
          fromActiveCampaign: proposal.fromActiveCampaign,
        ),
      ],
    );
  }
}

class _BodyHeader extends StatelessWidget {
  final String title;
  final DateTime lastUpdate;

  const _BodyHeader({
    required this.title,
    required this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final headerColor = _ProposalSubmitState.of(context)?.headerColor(context);
    final labelColor = _ProposalSubmitState.of(context)?.headerLabelColor(context);
    return Column(
      spacing: 2,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleSmall?.copyWith(
            color: headerColor,
          ),
        ),
        LastEditDate(
          dateTime: lastUpdate,
          showTimezone: false,
          textStyle: context.textTheme.labelMedium?.copyWith(
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _CampaignData extends StatelessWidget {
  final String leadValue;
  final String subValue;

  const _CampaignData({
    required this.leadValue,
    required this.subValue,
  });

  @override
  Widget build(BuildContext context) {
    final labelColor = _ProposalSubmitState.of(context)?.dataLabelColor(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          leadValue,
          style: context.textTheme.titleSmall?.copyWith(
            color: labelColor,
          ),
        ),
        Text(
          subValue,
          style: context.textTheme.labelMedium?.copyWith(
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _ProposalSubmitState extends InheritedWidget {
  final bool isSubmitted;

  const _ProposalSubmitState({
    required super.child,
    required this.isSubmitted,
  });

  Color backgroundColor(BuildContext context) => isSubmitted
      ? context.colors.onSurfacePrimary08
      : context.colors.elevationsOnSurfaceNeutralLv1White;

  Color dataLabelColor(BuildContext context) =>
      isSubmitted ? context.colors.primaryContainer : context.colors.textOnPrimaryLevel1;

  Color headerColor(BuildContext context) =>
      isSubmitted ? context.colors.textOnPrimaryWhite : context.colors.textOnPrimaryLevel0;

  Color headerLabelColor(BuildContext context) =>
      isSubmitted ? context.colors.textOnPrimaryWhite : context.colors.textOnPrimaryLevel1;

  @override
  bool updateShouldNotify(covariant _ProposalSubmitState oldWidget) {
    if (oldWidget.isSubmitted != isSubmitted) {
      return true;
    }
    return false;
  }

  static _ProposalSubmitState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_ProposalSubmitState>();
  }
}
